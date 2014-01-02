class Hint
  attr_accessor :text, :step, :href, :options

  def initialize(text, step, href = '', options = {})
    @text = text
    @step = step
    @href = href
    @options = options
  end
end