require 'spec_helper'
require 'roar_extensions'

describe Roar::Representer::JSON::HAL do
  module AttributesContructor
    def initialize(attrs={})
      attrs.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
  end

  class Item
    include AttributesContructor
    attr_accessor :value
  end

  class Order
    include AttributesContructor
    attr_accessor :id, :items
  end

  describe "_embedded key type" do
    it "defaults the _embedded key to be a string" do
      Bla = Module.new do
        include Roar::Representer::JSON::HAL
        property :value
        link :self do
          "http://items/#{value}"
        end
      end
      
      @order_rep = Module.new do
        include Roar::Representer::JSON::HAL
        property :id
        collection :items, :class => Item, :extend => Bla, :embedded => true
        link :self do
          "http://orders/#{id}"
        end
      end

      @order = Order.new(:items => [Item.new(:value => "Beer")], :id => 1).extend(@order_rep)

      @order.to_hash.should have_key('_embedded')
    end
  end
end
