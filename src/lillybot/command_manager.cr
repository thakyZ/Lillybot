module Lillybot
  # Quick to use command manager based on
  # [discordcr-middleware](https://github.com/z64/discordcr-middleware)
  # and [discordcr-plugin](https://github.com/z64/discordcr-plugin).
  #
  # Example command:
  # ```
  # module Lillybot::Commands::Core
  #   class Example
  #     include Discord::Plugin
  #
  #     @[Discord::Handler(
  #       event: :message_create,
  #       middleware: Middlewares::CommandMiddleware.new(
  #         name: "example",
  #         category: "Core",
  #         description: "Example of a command"
  #       )
  #     )]
  #     def example(payload, _ctx)
  #       client.create_message(payload.channel_id, "Answer")
  #     end
  #   end
  # end
  # ```
  class CommandManager
    record(Command,
      name        : String,
      category    : String,
      description : String,
      args        : Array(String) | Nil = nil,
      prefixed    : Bool = true,
      owner_only  : Bool = false,
      hidden      : Bool = false
    )

    def initialize
      @commands = Hash(String, Command).new
    end

    # Returns all commands that was previously added.
    def all : Array(Command)
      @commands.values
    end

    # Like `#all` but only with commands
    # that are in the given category.
    def all_in_category(category : String) : Array(Command)
      @commands.values.select { |c| c.category == category }
    end

    # Adds a command which can be obtained later.
    def add(**args)
      command = Command.new(**args)
      @commands[command.name] = command
    end

    # Returns all categories that commands contains.
    def categories : Array(String)
      categories = Array(String).new
      @commands.values.each do |command|
        next if categories.includes?(command.category)
        categories << command.category
      end
      categories
    end

    # Returns all commands in relevant categories.
    def categorized : Hash(String, Array(Command))
      categorized_commands = Hash(String, Array(Command)).new
      categories.each do |category|
        categorized_commands[category] = all_in_category(category)
      end
      categorized_commands
    end

    # Returns a command.
    def [](name : String) : Command
      @commands[name]
    end

    # Like `#[]` but returns `nil` if a command doesn't exists.
    def []?(name : String) : Command | Nil
      @commands[name]?
    end
  end
end
