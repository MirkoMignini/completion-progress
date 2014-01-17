require_relative 'engine'

module CompletionProgress

  def self.included(base)
    base.extend CompletionProgress::ClassMethods
    super
  end

  module ClassMethods

    @@engines = Hash.new

    def completion_progress(name, options = {}, &block)
      engine = @@engines[name]
      if engine == nil
        engine = Engine.new(options, &block)
        @@engines[name] = engine
        define_method(name) do
          engine.parent = self
          engine
        end
      end
      engine.instance_eval(&block) if block
    end
  end
end