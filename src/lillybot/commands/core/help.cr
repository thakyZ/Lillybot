module Lillybot::Commands::Core
  class Help
    include Discord::Plugin

    @[Discord::Handler(
      event: :message_create,
      middleware: Middlewares::CommandMiddleware.new(
        name: "help",
        category: "Core",
        description: "Shows all available commands or displays help for a specific command",
        args: ["command"]
      )
    )]
    def help(payload, _ctx)
      content = payload.content
      prefix = Lillybot.config.prefixes[0]
      command_name = content.lchop("#{prefix}help").lstrip

      embed = Discord::Embed.new
      embed.colour = Lillybot.config.embed_colour

      bot = client.get_current_user

      avatar_url = "https://images.discordapp.net/avatars/#{bot.id}/#{bot.avatar}.png"

      if command_name.empty?
        embed.author = Discord::EmbedAuthor.new(
          icon_url: avatar_url,
          name: "Commands"
        )

        fields = Array(Discord::EmbedField).new
        Lillybot.commands.categorized.each do |category, commands|
          fields << Discord::EmbedField.new(
            name: category,
            value: String.build do |string|
              commands.each do |command|
                next if command.hidden

                string << "`" << prefix if command.prefixed
                string << command.name << "` - "
                string << command.description << "\n"
              end
              string << "No commands available!" if string.empty?
            end
          )

          embed.fields = fields
        end
      else
        return unless Lillybot.commands[command_name]?
        command = Lillybot.commands[command_name]
        return if command.owner_only && !Utils.bot_owner?(payload.author.id)

        embed.author = Discord::EmbedAuthor.new(
          icon_url: avatar_url,
          name: "Command"
        )

        embed.title = String.build do |string|
          string << prefix if command.prefixed
          string << command.name

          args = command.args
          if args
            string << " "
            string << args.join(", ") do |arg|
              "`" + arg + "`"
            end
          end
        end

        embed.description = <<-DESCRIPTION
        #{command.description}

        **Category:** #{command.category}
        DESCRIPTION

        embed.footer = Discord::EmbedFooter.new(
          text: "This command is available only to the bot owner."
        ) if command.owner_only
      end

      client.create_message(payload.channel_id, "", embed)
    end
  end
end
