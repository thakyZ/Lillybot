module Lillybot::Commands::Core
  class Stats
    include Discord::Plugin

    @[Discord::Handler(
      event: :message_create,
      middleware: Middlewares::CommandMiddleware.new(
        name: "stats",
        category: "Core",
        description: "Shows bot statistics"
      )
    )]
    def stats(payload, _ctx)
      embed = Discord::Embed.new
      embed.colour = Lillybot.config.embed_colour

      bot = client.get_current_user
      embed.author = Discord::EmbedAuthor.new(
        icon_url: "https://images.discordapp.net/avatars/#{bot.id}/#{bot.avatar}.png",
        name:     "Statistics"
      )

      fields = Array(Discord::EmbedField).new
      fields << Discord::EmbedField.new(
        name: "Common",
        value: String.build do |string|
          string << "**Latency:** "
          client.trigger_typing_indicator(payload.channel_id)
          string << (payload.timestamp - Time.local).milliseconds << "ms\n"

          uptime = (Time.local - Lillybot.start_time)
          string << "**Uptime:** "
          string << uptime.days << "d "
          string << uptime.hours << "h "
          string << uptime.minutes << "m "
          string << uptime.seconds << "s"
        end,
        inline: true
      )
      fields << Discord::EmbedField.new(
        name: "Process",
        value: String.build do |string|
          memory_kb = `pmap #{Process.pid} | tail -n 1`.split[1][0..-2].to_i
          memory_mb = (memory_kb / 1024).round(1)
          string << "**RAM:** " << memory_mb << "MB"

          string << "\n"

          cpu = `ps -p #{Process.pid} -o %cpu`.split("\n")[1]
          string << "**CPU:** " << cpu << "%"
        end,
        inline: true
      )

      cache = client.cache
      if cache
        fields << Discord::EmbedField.new(
          name: "Cache",
          value: String.build do |string|
            string << "**Guilds:** " << cache.guilds.keys.size << "\n"
            string << "**Channels:** " << cache.channels.keys.size << "\n"

            members = Array(UInt64).new
            cache.members.each do |guild_id, guild_members|
              members = members + guild_members.keys
            end
            string << "**Members:** " << members.uniq.size
          end,
          inline: true
        )
      end
      embed.fields = fields

      client.create_message(payload.channel_id, "", embed)
    end
  end
end
