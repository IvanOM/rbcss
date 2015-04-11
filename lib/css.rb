module CSS
  class Node
    def initialize
      @children = {selectors: [], properties: [], media_selectors: []}
    end
    
    def to_s
      msg = ""
      @children.each do |type, children|
        if !children.empty?
          children.each do |node|
            msg += node.to_s
          end
        end
      end
      return msg
    end

    # Write a css property declaration with the name of the called method
    # @param method [Symbol] the called method name as a symbol
    def property method, *args
      @children[:properties] << CSS::Property.new(method, args[0])
    end

    # Write a css selector declaration to $stdout
    # @param selector [String] the selector name or string
    def selector selector, &block
      @children[:selectors] << CSS::Selector.new(selector, &block)
    end
    
    def media_selector selector, &block
      @children[:media_selectors] << CSS::MediaSelector.new(selector, &block)
    end
    
    private
    
    def selectors
      @children[:selectors]
    end
    
    def properties
      @children[:properties]
    end
    
    def media_selectors
      @children[:media_selectors]
    end
    
    def method_missing name, *args, &block
      send(:selector, *args, &block) if block && !args[0].include?("@media")
      send(:media_selector, *args, &block) if block && args[0].include?("@media")
      send(:property, name, *args) if args[0] and !block
    end
  end
  
  class Selector < Node
    attr_accessor :name

    def initialize name, &block
      super()
      @name = name
      send(:instance_eval, &block)
    end
    
    def children_to_s
      msg = ''
      children = properties + media_selectors
      children.each do |node|
        msg += node.to_s
      end
      msg = "#{@name}{#{msg}}" if !children.empty?
      return msg
    end

    def to_s
      msg = ''
      
      msg = children_to_s
      
      selectors.each do |selector|
        node = selector.clone
        parent_selectors = @name.split(',').map(&:strip)
        child_selectors = node.name.split(',').map(&:strip)
        combination = parent_selectors.product(child_selectors)
        combination.map! {|element| element.join(' ') }
        node.name = "#{combination.join(',')}"
        msg << node.to_s
      end
      return msg
    end
  end
  
  class MediaSelector < Node
    def initialize selector, &block
      super()
      @selector = selector
      send(:instance_eval, &block)
    end
    
    def to_s
      "#{@selector}{#{super}}"
    end
  end
  
  class Property < Node
    def initialize name, value
      super()
      @name = name
      @value = value
    end
    
    def to_s
      "#{@name.to_s.gsub('_', '-')}:#{@value};"
    end
  end
  
  class Style < Node
    def initialize &block
      super()
      send(:instance_eval, &block)
    end
  end
end

class CSSOld

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
