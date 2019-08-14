module Lillybot::Utils
  def self.bot_owner?(id : UInt64 | Discord::Snowflake)
    Lillybot.config.owner_ids.any? { |owner_id| owner_id == id }
  end
end
