require "css"

RSpec.describe CSS, :type => :module do
  describe "#style" do
    it "calls module_eval method" do
      expect(CSS).to receive(:module_eval)
      CSS.style do
      end
    end
  end

  describe "#property" do
    it "prints a css property declaration to $stdout" do
      expect{
        CSS.style do
          property "color", "green"
        end
      }.to output("color:green;").to_stdout
    end
  end

  describe "#selector" do
    it "prints a css selector declaration to $stdout" do
      expect{
        CSS.style do
          selector("body"){}
        end
      }.to output("body{}").to_stdout
    end

    it "yields to a block with properties declarations" do
      expect{
        CSS.style do
          selector("body"){
            color "green"
          }
        end
      }.to output("body{color:green;}").to_stdout
    end
  end

  describe "calls to the inexistent method to" do
    context "with an argument and a block" do
      it "prints a css selector declaration to $stdout" do
        expect{
          CSS.style do
            to("body"){}
          end
        }.to output("body{}").to_stdout
      end
    end

    context "with just an argument" do
      it "prints a css property declaration to $stdout" do
        expect{
          CSS.style do
            to "body"
          end
        }.to output("to:body;").to_stdout
      end
    end
  end
end
