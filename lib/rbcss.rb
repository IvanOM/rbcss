require "rbcss/version"
require "tilt"
require "css"

module Rbcss
  class Template < ::Tilt::Template
    self.default_mime_type = "text/css"
    
    def prepare
      @data = "$LOAD_PATH.unshift('#{File.dirname(File.expand_path(@file))}');require 'css';CSS.style do;#{File.read(@file)}\nend"
    end

    def evaluate(scope, locals, &block)
      pipe = IO.popen("ruby -W0 2>&1", "w+")
      pipe.write @data
      pipe.close_write
      data = pipe.read
      pipe.close
      return data if $? == 0
      raise data
    end
  end
end
