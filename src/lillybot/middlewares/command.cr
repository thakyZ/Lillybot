module Lillybot::Middlewares
  # Checks if a message contains command call
  class CommandMiddleware
    def initialize(
      @name        : String,
      @category    : String,
      @description : String,
      @args        : Array(String) | Nil = nil,
      @prefixed    : Bool = true,
      @owner_only  : Bool = false,
      @hidden      : Bool = false
    )
      Lillybot.commands.add(
        name:        @name,
        category:    @category,
        description: @description,
        args:        @args,
        prefixed:    @prefixed,
        owner_only:  @owner_only,
        hidden:      @hidden
      )
    end

    def call(payload : Discord::Message, ctx : Discord::Context)
      return if payload.author.bot

      content = payload.content

      if @prefixed
        prefixes = Lillybot.config.prefixes
        prefixes.each do |prefix|
          if content.starts_with?(prefix)
            content = content.lchop(prefix).strip
            break
          end
          return if prefix = prefixes[-1]
        end
      end

      yield if content.starts_with?(@name)
    end
  end
end
