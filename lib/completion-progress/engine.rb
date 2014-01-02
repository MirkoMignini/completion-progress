require_relative 'step'

class Engine
  attr_accessor :parent, :auto_update, :steps, :hints, :value, :percent

  def initialize(options = {}, &block)
    @value = 0
    @percent = 0
    @hints = Array.new
    @auto_update = options.has_key?(:auto_update) ? options[:auto_update] : true
    @steps = Hash.new
  end

  def step(name, value, options = {}, &block)
    if !@steps.has_key?(name)
      @steps[name] = Step.new(name, value, options, &block)
    end
  end

  def update
    @value = 0
    @percent = 0
    @hints = Array.new
    @steps.each do |key, step|
      if step.process(parent)
        @value += step.value
      else
        #todo hint
      end
    end
    #todo percent
  end

  def value
    update if @auto_update
    @value
  end

  def percent
    update if @auto_update
    @percent
  end

  def hints
    update if @auto_update
    @hints
  end
end