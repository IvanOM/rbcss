# Rbcss

This is just a Ruby DSL library to express the CSS structure as Ruby code. Expressing CSS using a DSL permits the use of all the capabilities of the host language like: functions, classes, modules, variables, hashes, array etc.

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

In a ruby file, require css lib file and pass a block to CSS.style function:

```ruby
require 'css'

CSS.style do
  to('body'){
    background_color "green"
  }
  to('section.main div:nth-of-type(1)'){
    width '100%'
    height '64px'
  }
end
```
Run your file with Ruby and that is all. You will have a new css file with the same name as your ruby file.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rbcss/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
