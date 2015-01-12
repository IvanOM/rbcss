require "rbcss"

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
      before do
        allow(File).to receive(:read).and_return(
          """
          @media max-width(300px){
            color:green;
            body{
              -webkit-animation:expand 1s linear;
            }
            border:1px solid green;
            }
          """
        )
      end
      it "converts a css file to Ruby code" do
        expect{
          rbcss = RBCSS::Application.new(["convert", "mycss.css", "to-ruby"])
          rbcss.run
        }.to output(
"""require 'css'

CSS.style do
  to('@media max-width(300px)'){
    color 'green'
    to('body'){
      _webkit_animation 'expand 1s linear'
    }
  }
end"""
        ).to_stdout
      end
    end
  end
end
