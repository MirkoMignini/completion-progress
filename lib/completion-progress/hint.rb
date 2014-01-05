class Hint
  attr_accessor :step, :text, :href, :options

  def initialize(step, text, href = '', options = {})
    @step = step
    @text = text
    @href = href
    @options = options
  end
end