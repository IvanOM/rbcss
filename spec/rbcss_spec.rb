require "rbcss"
String.class_eval do
  def align_left
    string = dup
    string[0] = '' if string[0] == "\n"
    string[-1] = '' if string[-1] == "\n"
    relevant_lines = string.split(/\r\n|\r|\n/).select { |line| line.size > 0 }
    indentation_levels = relevant_lines.map do |line|
      match = line.match(/^( +)[^ ]+/)
      match ? match[1].size : 0
    end
    indentation_level = indentation_levels.min
    string.gsub! /^#{' ' * indentation_level}/, '' if indentation_level > 0
    string
  end
end

RSpec.describe RBCSS, type: :module do
  describe "Application" do
    describe "#run" do
      context "valid command" do
        let(:rbcss) { RBCSS::Application.new(["convert", "mycss.css", "to-ruby"]) }
        before do
          allow(rbcss).to receive(:file)
          allow(rbcss).to receive(:extension)
        end
        it "sends a message to correlated method" do
          expect(rbcss).to receive(:convert).with("mycss.css", "to-ruby")
          rbcss.run
        end
      end
    end

    describe "#convert" do
      context "converts a css block" do
        before do
          allow(File).to receive(:read).and_return(
            """
              body{
                -webkit-animation:expand 1s linear;
              }
            """
          )
        end
        it "converts a css file to Ruby code" do
          expect{
            rbcss = RBCSS::Application.new(["convert", "mycss.css", "to-ruby"])
            rbcss.run
          }.to output(
            <<-text.align_left
            require 'css'

            CSS.style do
              to('body'){
                _webkit_animation 'expand 1s linear'
              }
            end
            text
          ).to_stdout
        end
      end
    end
  end
end
