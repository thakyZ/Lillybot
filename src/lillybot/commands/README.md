Example command:
```crystal
module Lillybot::Commands::Core
  class Example
    include Discord::Plugin

    @[Discord::Handler(
      event: :message_create,
      middleware: Middlewares::CommandMiddleware.new(
        name: "example",
        category: "Core",
        description: "Example of a command"
      )
    )]
    def example(payload, _ctx)
      client.create_message(payload.channel_id, "Answer")
    end
  end
end
```
