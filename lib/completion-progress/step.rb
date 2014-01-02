class Step
  attr_accessor :name, :value, :block, :status

  def initialize(name, value, options = {}, &block)
    @name = name
    @value = value
    @block = block
    @status = false
  end

  def process(obj)
    begin
      if !@block
        val = obj.send(@name)
        if val.kind_of?(Array) or val.kind_of?(Hash)
          @status = val.count == 0 ? false : true
        else
          @status = val
        end
      else
        @status = obj.eval(@block)
      end
    rescue Exception => e
      puts e.message
      @status = false
    end
    @status
  end
end