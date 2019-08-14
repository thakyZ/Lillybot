require "yaml"

module Lillybot
  struct Config
    # Parses config from a string.
    def self.parse(string : String)
      Config.from_yaml(string)
    end

    # Parses config from a file.
    def self.parse_file(path : String)
      Config.from_yaml(File.open(path))
    end

    include YAML::Serializable

    getter prefixes : Array(String)
    getter owner_ids : Array(UInt64)
    getter embed_colour : UInt32

    getter shards : ConfigShards
    getter logger : ConfigLogger

    struct ConfigShards
      include YAML::Serializable

      getter token : String
      getter client_id : UInt64
      getter num_shards : Int32
    end

    struct ConfigLogger
      include YAML::Serializable

      getter severity : String
    end
  end
end
