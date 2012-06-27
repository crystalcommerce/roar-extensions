require 'spec_helper'
require 'roar_extensions'

class PopBand
  include Representable::JSON
  property :name
  property :groupies
  attr_accessor :name, :groupies
end

class SkaBand
  include Representable::JSON
  property :name
  property :groupies, :render_nil => true
  attr_accessor :name, :groupies
end

describe Representable do
  describe "#create_representation_with" do
    let(:band) { PopBand.new }

    before(:each) do
      band.name = "No One's Choice"
    end

    context "nil attributes" do
      before(:each) do
        band.groupies = nil
      end

      it "does not write them" do
        band.send(:create_representation_with, {}, {}, Representable::JSON).
          should == {"name" => "No One's Choice"}
      end

      context "render_nil => true" do
        let(:band) { SkaBand.new }

        it "includes the attribute with value nil" do
          band.send(:create_representation_with, {}, {}, Representable::JSON).
            should == {"name" => "No One's Choice", "groupies" => nil}
        end
      end
    end

    context "false attributes" do
      before(:each) do
        band.groupies = false
      end

      it "does writes them" do
        band.send(:create_representation_with, {}, {}, Representable::JSON).
          should == {"name" => "No One's Choice", "groupies" => false}
      end
    end
  end

  describe "#update_properties_from" do
    let(:band) { PopBand.new }

    it "allows false attributes" do
      band.update_properties_from({"groupies" => false}, {}, Representable::JSON)
      band.groupies.should == false
    end
  end
end
