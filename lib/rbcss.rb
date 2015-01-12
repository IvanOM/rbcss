require "rbcss/version"

module RBCSS
  class Application

    def initialize(argv)
      @command = argv[0]
      @file_name = argv[1]
      @extension = argv[2]
    end

    def run
      self.convert(@file_name, @extension) if @command == "convert"
    end

    def convert file, extension
      if extension == "to-ruby"
        content = File.read(file)
        blocks = break_by(content, '}')
        selectors = separate_selector blocks
        $stdout.write "require 'css'\n\nCSS.style do\n"
        parse_selectors selectors
        $stdout.write "end"
      end
    end

    private

    def parse_selectors selectors
      parse selectors do |selector, properties|
        $stdout.write "  to('#{selector}'){\n"
        parse properties do |property, value|
          $stdout.write "    #{property.gsub('-', '_')} '#{value}'"
        end
        $stdout.write "\n  }\n"
      end
    end

    def parse list, &block
      list.each do |item|
        item.each do |key, value|
          yield key, value
        end
      end
    end

    def break_by text, separator
      text.split(separator).collect(&:strip).reject(&:empty?)
    end

    def separate_properties block
      block.map do |declaration|
        declaration = break_by(declaration, ':')
        {declaration[0] => declaration[1]}
      end
    end

    def separate_selector block
      block.map do |declaration|
        selector, properties = break_by(declaration, '{')
        properties_list = break_by(properties, ';')
        properties = separate_properties(properties_list)
        {selector => properties}
      end
    end
  end
end
