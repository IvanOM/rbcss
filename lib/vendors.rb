module Vendors
  attr_accessor :vendored_properties
  
  def self.extended object
    object.instance_eval do
      @vendored_properties = {}
    end
  end
  
  def property method, *args, &block
    super method, *args, &block
    if vendored_properties.keys.include? method
      vendored_properties[method].each do |vendor|
        super :"_#{vendor}_#{method}", *args, &block 
      end
    end
  end
end