require "discordcr"
require "discordcr-plugin"

module Lillybot
  module Shards
    class_getter shards = [] of Shard

    class Shard
      getter client : Discord::Client
      getter cache  : Discord::Cache
      delegate run, stop, to: client

      def initialize(token : String, client_id : UInt64,
                     num_shards : Int32, shard_id : Int32,
                     logger : Logger)
        @client = Discord::Client.new(
          token: "Bot #{token}",
          client_id: client_id,
          shard: {
            num_shards: num_shards,
            shard_id: shard_id
          },
          logger: logger
        )

        @cache = Discord::Cache.new(@client)
        @client.cache = @cache

        register_plugins(@client)
      end

      private def register_plugins(client)
        Discord::Plugin.plugins.each { |plugin| client.register(plugin) }
      end
    end

    # Starts all shards with given parameters.
    def self.start(token : String, client_id : UInt64,
                   num_shards : Int32, logger : Logger)
      num_shards.times do |shard_id|
        shard = Shard.new(token, client_id, num_shards, shard_id, logger)
        @@shards << shard
        spawn { shard.run }
      end
    end

    # Stops all shards.
    def self.stop
      @@shards.each { |shard| shard.stop }
    end

    # Returns the shard which is used for the guild.
    def self.guild_shard(guild_id : UInt64 | Discord::Snowflake)
      shard_id = (guild_id >> 22) % config.shard_count
      @@shards[shard_id]
    end
  end
end
