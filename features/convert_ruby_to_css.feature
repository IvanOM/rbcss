Feature: Converting Ruby DSL code to CSS

  In order to have flexibility to write CSS
  As an user
  I want to write CSS in Ruby DSL and execute the file

  Scenario: A simple block of code
    Given a file named "mycss.rb" with:
      """
      require 'css'
      
      css = CSS.new
      css.style do
        to('body'){
          _webkit_animation "expand 1s linear"
        }
      end
      """
    When I run `ruby mycss.rb`
    Then the output should contain:
      """
      body{-webkit-animation:expand 1s linear;}
      """

  Scenario: A nested block of code
    Given a file named "mycss.rb" with:
      """
      require 'css'

      css = CSS.new
      css.style do
        to('@media (max-width: 800px)'){
          to('body'){
            _webkit_animation "expand 1s linear"
          }
        }
      end
      """
    When I run `ruby mycss.rb`
    Then the output should contain:
      """
      @media (max-width: 800px){body{-webkit-animation:expand 1s linear;}}
      """
