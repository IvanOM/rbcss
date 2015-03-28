require 'vendors'

class CSS
  
  def initialize
    self.extend Vendors
  end

  # Send a message to the instance_eval method of a CSS instace. It is just an Alias.
  # @param &block [Proc] the code block to be executed in the CSS instance context
  def style &block
    send :instance_eval, &block
  end

  # Write a css selector declaration to $stdout
  # @param selector [String] the selector name or string
  def selector selector, &block
    $stdout.write "#{selector}{"; yield; $stdout.write "}"
  end

  # Write a css property declaration with the name of the called method
  # @param method [Symbol] the called method name as a symbol
  def property method, *args, &block
    $stdout.write "#{method.to_s.gsub('_', '-')}:#{args[0]};"
  end

  private

  def method_missing name, *args, &block
    send(:selector, *args, &block) if block
    send(:property, name, *args, &block) if args[0] and !block
  end

end
