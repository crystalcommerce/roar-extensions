require 'spec_helper'
require 'roar_extensions'

describe Roar::Representer::JSON::HAL do
  describe "Hypermedia Feature" do
    describe "Hypermedia.link" do
      let(:mod) do
        Module.new do
          include Roar::Representer::JSON
          include Roar::Representer::Feature::Hypermedia
        end
      end

      it "accepts strings for rel" do
        mod.class_eval do
          link :rel => 'self', :title => "Hey, @myabc" do
            "http://self"
          end
        end

        Object.new.extend(mod).to_hash['links'][0][:rel].should == 'self'
      end
    end
  end
end
