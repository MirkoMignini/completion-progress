require_relative 'hint'

class Step
  attr_accessor :name, :value, :block, :status, :hint

  def initialize(name, value, options = {}, &block)
    @name = name
    @value = value
    @block = block
    @status = false

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
        @status = val.count == 0 ? false : true
      else
        @status = val
      end

    rescue Exception => e
      @status = false
    ensure
      @status
    end
  end
end