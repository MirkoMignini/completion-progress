require_relative 'engine'

module CompletionProgress

  def self.included(base)
    base.extend CompletionProgress::ClassMethods
    super
  end

  module ClassMethods

    def completion_progress(name, options = {}, &block)

      if !respond_to?(name)
        engine = Engine.new(options, &block)
        define_method(name) do
          engine.parent = self
          engine
        end
      else
        engine = send(name)
      end
      engine.instance_eval(&block) if block
    end
  end
end