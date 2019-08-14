module Lillybot::Commands::Core
  class About
    include Discord::Plugin

    @[Discord::Handler(
      event: :message_create,
      middleware: Middlewares::CommandMiddleware.new(
        name: "about",
        category: "Core",
        description: "Shows information about the bot"
      )
    )]
    def about(payload, _ctx)
      embed = Discord::Embed.new
      embed.colour = Lillybot.config.embed_colour

      bot = client.get_current_user
      embed.author = Discord::EmbedAuthor.new(
        icon_url: "https://images.discordapp.net/avatars/#{bot.id}/#{bot.avatar}.png",
        name:     "Lillybot"
      )

      invite = "[Invite](https://discordapp.com/api/oauth2/authorize?client_id=442066791200456724&permissions=384192&scope=bot)"
      repo = "[Repository](http://github.com/SanksTheYokai/Lillybot)"
      embed.description = "#{invite} • #{repo}"

      fields = Array(Discord::EmbedField).new
      fields << Discord::EmbedField.new(
        name: "Language",
        value: "Crystal #{Crystal::VERSION}",
        inline: true
      )
      fields << Discord::EmbedField.new(
        name: "Library",
        value: "discordcr #{Discord::VERSION}",
        inline: true
      )
      embed.fields = fields

      client.create_message(payload.channel_id, "", embed)
    end
  end
end
