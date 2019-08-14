Example event:
```crystal
module Lillybot::Events
  class Example
    include Discord::Plugin

    @[Discord::Handler(event: :ready)]
    def example(payload)
      puts "Ready!"
    end
  end
end
