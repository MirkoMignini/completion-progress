require_relative 'step'

class Engine
  attr_reader :auto_update, :steps, :hints, :value, :percent, :total_value
  attr_accessor :parent

  def initialize(options = {})
    @value = 0
    @total_value = 0
    @percent = 0
    @hints = Hash.new
    @steps = Hash.new
    @auto_update = options.has_key?(:auto_update) ? options[:auto_update] : true
  end

  def step(name, value, options = {}, &block)
    if !@steps.has_key?(name)
      @steps[name] = Step.new(name, value, options, &block)
      @total_value += value
    end
  end

  def update
    @value = 0
    @hints = Hash.new
    @steps.each do |key, step|
      step.process(parent) ? @value += step.value : @hints[step.name] = step.hint
    end
    @percent = @value * 100 / @total_value
  end

  def value
    update if @auto_update
    @value
  end

  def steps
    update if @auto_update
    @steps
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