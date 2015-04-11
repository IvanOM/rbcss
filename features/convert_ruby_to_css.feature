Feature: Converting Ruby DSL code to CSS

  In order to have flexibility to write CSS
  As an user
  I want to write CSS in Ruby DSL and execute the file

  Scenario: A simple block of code
    Given a file named "mycss.rb" with:
      """
      require 'css'
      
      css = CSS::Style.new do
        to('body'){
          _webkit_animation "expand 1s linear"
        }
      end
      print css.to_s
      """
    When I run `ruby mycss.rb`
    Then the stdout should contain exactly:
      """
      body{-webkit-animation:expand 1s linear;}
      """

  Scenario: A selector block nested with a media block
    Given a file named "mycss.rb" with:
      """
      require 'css'

      css = CSS::Style.new do
        to('@media (max-width: 800px)'){
          to('body'){
            _webkit_animation "expand 1s linear"
          }
        }
      end
      print css.to_s
      """
    When I run `ruby mycss.rb`
    Then the stdout should contain exactly:
      """
      @media (max-width: 800px){body{-webkit-animation:expand 1s linear;}}
      """

  Scenario: Call to_s multiple times
    Given a file named "mycss.rb" with:
      """
      require 'css'
    
      css = CSS::Style.new do
        to('body'){
          to('h1'){
            color 'blue'
          }
        }
      end
      css.to_s
      print css.to_s
      """
    When I run `ruby mycss.rb`
    Then the stdout should contain exactly:
      """
      body h1{color:blue;}
      """

  Scenario: Nested blocks
    Given a file named "mycss.rb" with:
      """
      require 'css'
    
      css = CSS::Style.new do
        to('body'){
          to('h1'){
            color 'blue'
          }
        }
      end
      print css.to_s
      """
    When I run `ruby mycss.rb`
    Then the stdout should contain exactly:
      """
      body h1{color:blue;}
      """

  Scenario: Nested blocks and a property
    Given a file named "mycss.rb" with:
      """
      require 'css'
      
      css = CSS::Style.new do
        to('body'){
          to('h1'){
            color 'blue'
          }
          color 'red'
          to('h2'){
            color 'red'
          }
        }
      end
      print css.to_s
      """
    When I run `ruby mycss.rb`
    Then the stdout should contain exactly:
      """
      body{color:red;}body h1{color:blue;}body h2{color:red;}
      """
  
  Scenario: Combined nested blocks
    Given a file named "mycss.rb" with:
      """
      require 'css'
      
      css = CSS::Style.new do
        to('body, head section'){
          to('h1 p, div'){
            color "blue"
          }
          color "red"
          to('span, .clearfix'){
            color "green"
          }
        }
      end
      print css.to_s
      """
    When I run `ruby mycss.rb`
    Then the stdout should contain exactly:
      """
      body, head section{color:red;}body h1 p,body div,head section h1 p,head section div{color:blue;}body span,body .clearfix,head section span,head section .clearfix{color:green;}
      """
      
  Scenario: Complex deep nested blocks calling to_s multiple times
    Given a file named "mycss.rb" with:
      """
      require 'css'
      
      css = CSS::Style.new do
        to('body, head'){
          color "blue"
          to('div, p'){
            color "green"
            to('span, input'){
              color "red"
            }
            font "arial"
          }
          font "serif"
        }
      end
      
      css.to_s
      print css.to_s
      """
    When I run `ruby mycss.rb`
    Then the stdout should contain exactly:
      """
      body, head{color:blue;font:serif;}body div,body p,head div,head p{color:green;font:arial;}body div span,body div input,body p span,body p input,head div span,head div input,head p span,head p input{color:red;}
      """