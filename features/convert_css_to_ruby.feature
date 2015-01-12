Feature: Convert CSS structure to Ruby code

  In order to port an existing CSS code
  As an user
  I want to convert CSS to Ruby

  Scenario: Convert a block declaration
    Given a file named "mycss.css" with:
      """
      body{-webkit-animation:expand 1s linear;}
      """
    When I run `rbcss convert mycss.css to-ruby`
    Then the output should contain:
      """
      require 'css'

      CSS.style do
        to('body'){
          _webkit_animation 'expand 1s linear'
        }
      end
      """

  Scenario: Convert a nested block declaration
    Given a file named "mycss.css" with:
      """
      @media screen{
        body{
          -webkit-animation: expand 1s linear;
        }
        *{
          color: blue;
        }
      }
      """
    When I run `rbcss convert mycss.css to-ruby`
    Then the output should contain:
      """
      require 'css'

      CSS.style do
        to('@media screen'){
          to('body'){
            _webkit_animation 'expand 1s linear'
          }
          to('*'){
            color 'blue'
          }
        }
      }
      """
