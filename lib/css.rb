$stdout.reopen("#{$0.gsub('rb', 'css')}")
module CSS

  def self.style &block
    send :module_eval, &block
  end

  def self.selector selector, &block
    $stdout.write "#{selector}{"; yield; $stdout.write "}"
  end

  def self.property method, *args, &block
    $stdout.write "#{method.to_s.gsub('_', '-')}:#{args[0]};"
  end

  def self.method_missing name, *args, &block
      send(:selector, *args, &block) if args[0] and block
      send(:property, name, *args, &block) if args[0] and !block
  end

end
