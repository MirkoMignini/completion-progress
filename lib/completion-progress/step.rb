require_relative 'hint'

class Step
  attr_accessor :name, :value, :block, :result, :hint

  def initialize(name, value, options = {}, &block)
    @name = name
    @value = value
    @block = block
    @result = false

    if (options.has_key?(:hint))
      @hint = Hint.new(self, options[:hint][:text], options[:hint][:href], options[:hint][:options])
    else
      @hint = Hint.new(self, "Fill #{name}")
    end
  end

  def process(obj)
    begin

      if !@block
        val = obj.send(@name)
      else
        val = obj.instance_eval(&@block)
      end

      if val.kind_of?(Array) or val.kind_of?(Hash)
        @result = val.count == 0 ? false : true
      else
        @result = val
      end

    rescue Exception => e
      @result = false
    ensure
      @result ? @result = true : @result = false
    end
  end
end