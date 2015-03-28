require 'css'

RSpec.describe Vendors, type: :module do
  let(:css) { CSS.new }
  
  describe "#property" do
    before do
      css.vendored_properties[:animation] = [:webkit, :moz]
    end
    
    it "prints vendor prefixed properties when they are declared" do
      expect{
        css.style do
          animation "expand 1s linear"
        end
      }.to output(
        "animation:expand 1s linear;-webkit-animation:expand 1s linear;-moz-animation:expand 1s linear;"
        ).to_stdout
    end
    
    it "prints just the declared property when no vendor was declared" do
      expect{
        css.style do
          color "blue"
        end
      }.to output("color:blue;").to_stdout
    end
  end
end