require 'spec_helper'
require 'roar_extensions'

module RoarExtensions::Helpers
  describe EmbeddedParameterParsing do
    class MyTestController
      def self.before_filter(*args)
        # yup
      end
    end

    subject { MyTestController.new }

    describe "including into a class" do
      it "calls before_filter" do
        MyTestController.should_receive(:before_filter).with(:parse_embedded_params_filter)
        MyTestController.send(:include, EmbeddedParameterParsing)
      end
    end

    describe "parse_embedded_params" do
      before(:each) do
        MyTestController.send(:include, EmbeddedParameterParsing)
      end
      it "returns empty array for blank string" do
        subject.parse_embedded_params("").should == []
      end

      it "returns empty array for nil" do
        subject.parse_embedded_params(nil).should == []
      end

      it "returns the given list if comma-separated as symbols" do
        subject.parse_embedded_params("foo,bar").should == [:foo, :bar]
      end

      it "recursively parses nested embeddings" do
        subject.parse_embedded_params("line_items:product,line_items:variant,customer,address:ip_address").should == [
          :customer,
          {:line_items => [:product, :variant], :address => [:ip_address]}
        ]
      end

      it "recurses multiple levels" do
        subject.parse_embedded_params("customer,line_items:product:category").should == [
          :customer,
          {:line_items => [{:product => [:category]}]}
        ]
      end
    end
  end
end
