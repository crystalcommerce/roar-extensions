require 'spec_helper'
require 'roar_extensions'

describe RoarExtensions do
  describe ".base_url" do
    before(:each) do
      RoarExtensions.base_url = nil
    end

    it "is a configuration option" do
      RoarExtensions.base_url = 'foo'
      RoarExtensions.base_url.should == 'foo'
    end

    context "not yet set" do
      it "raises an informative error" do
        expect {
          RoarExtensions.base_url
        }.to raise_error("Set base url like RoarExtensions.base_url = 'http://example.com'")
      end
    end
  end
end
