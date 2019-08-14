require "logger"

require "./lillybot/*"
require "./lillybot/middlewares/*"
require "./lillybot/commands/**"
require "./lillybot/events/**"

module Lillybot
  class_getter config     = Config.parse_file("./src/config.yml")
  class_getter commands   = CommandManager.new
  class_getter start_time = Time.local

  logger = Logger.new(STDOUT, Logger::Severity.parse(@@config.logger.severity))
  logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << "[" << severity << "]" << message
  end

  Shards.start(
    @@config.shards.token,
    @@config.shards.client_id,
    @@config.shards.num_shards,
    logger
  )

  sleep
end
