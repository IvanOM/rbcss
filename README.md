# RBCSS

This is a Ruby DSL library to express the CSS structure as Ruby code. Expressing CSS using a DSL permits the use of all the capabilities of the host language like: functions, classes, modules, variables, hashes, array etc.

This library does not intend to make CSS property or value validations, this was left to CSS itself. The purpose here is add dynamic capabilities while writing CSS code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbcss'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbcss

## Usage

### Basic Usage
In a ruby file, require css and pass a block to CSS.style function:

```ruby
require 'css'

CSS.style do
  to("body"){
    background_color "green"
  }
  to("section.main div:nth-of-type(1)"){
    width "100%"
    height "64px"
  }
end
```
Run your file with Ruby and the output will be echoed to $stdout.

### Writing to a file

You can add a $stdout.reopen above CSS.style call to change the $stdout to a file with the same name as your Ruby file but with .css extension:

```ruby
require 'css'

$stdout.reopen("#{$0.gsub('rb', 'css')}")
CSS.style do
  #...
end
```
or you can use shell:

  $ ruby mycss.rb > mycss.css

### Adding functionality

You can create mixins with modules:

```ruby
require 'css'

module Shadow
  def shadow(color: "grey")
    box_shadow "0px 0px 7px 1px #{color}"
    _webkit_shadow "0px 0px 7px 1px #{color}"
  end
end

CSS.style do
  extend Shadow

  to("body"){
    background_color "green"
  }
  to("section.main div:nth-of-type(1)"){
    width "100%"
    height "64px"
    shadow "rgba(0, 0, 0, 0.12)"
  }
end
```

## Contributing

1. Fork it ( https://github.com/IvanOM/rbcss/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
