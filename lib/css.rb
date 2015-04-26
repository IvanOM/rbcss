module CSS
  class Node
    def initialize *args, &block
      @children = []
      send(:instance_eval, &block) if block_given?
    end

    def to_s
      collection_css(@children)
    end

    private

    def selectors
      @children.select { |c| c.is_a? CSS::Selector }
    end

    def properties
      @children.select { |c| c.is_a? CSS::Property }
    end

    def media_selectors
      @children.select { |c| c.is_a? CSS::MediaSelector }
    end

    def collection_css(collection)
      collection.reduce("") do |msg, node|
        msg += node.to_s
      end
    end

    def method_missing method, value, *args, &block
      if block_given?
        @children << CSS::Selector.new(value, &block) if !value.include?("@media")
        @children << CSS::MediaSelector.new(value, &block) if value.include?("@media")
      else
        @children << CSS::Property.new(method, value) if value
      end
    end
  end

  class Selector < Node
    attr_accessor :name

    def initialize name, &block
      @name = name
      super()
    end

    def to_s
      msg = ''

      msg = "#{@name}{#{collection_css(not_selectors)}}" if not_selectors.any?

      selectors.each do |selector|
        node = selector.clone
        node.name = "#{combine_with(node).join(',')}"
        msg << node.to_s
      end
      return msg
    end

    def split_selectors
      @name.split(',').map(&:strip)
    end

    def combine_with(node)
      split_selectors.product(node.split_selectors).map { |element| element.join(' ') }
    end

    def not_selectors
      @children.reject { |c| c.is_a? CSS::Selector }
    end
  end

  class MediaSelector < Node
    def initialize selector, &block
      @selector = selector
      super()
    end

    def to_s
      "#{@selector}{#{super}}"
    end
  end

  class Property < Node
    def initialize name, value
      @name = name
      @value = value
      super()
    end

    def to_s
      "#{@name.to_s.gsub('_', '-')}:#{@value};"
    end
  end

  class Style < Node
  end
end
