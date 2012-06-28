require 'spec_helper'
require 'roar_extensions'

module RoarExtensions
  describe Presenter do

    class TestPhotoPresenter
      include Presenter

      root_element :photo

      delegated_property :position
    end

    class TestProductPresenter
      include Presenter

      root_element :product

      delegated_property :id
      delegated_property :name
      delegated_property :is_buying,      :from => :buying?
      delegated_property :msrp,           :as => MoneyPresenter
      property :possible_variants_count
      property :min_sell_price,           :as => MoneyPresenter
      property :catalog_links,            :from => :catalog_links_as_json
      delegated_collection :photos,       :as => TestPhotoPresenter, :embedded => true

      link(:rel => "self")             { "/v1/products/#{record.id}" }
      link(:rel => "category")         { "/v1/categories/#{record.category_id}" }
      link(:rel => "related_products") { "/v1/products/#{record.id}/related" }

      def initialize(record, options = {})
        super(record)

        @embedded = options.fetch(:embedded, [])
      end

      private

      def min_sell_price
        OpenStruct.new(:cents => 499,
                       :currency => OpenStruct.new(:iso_code => 'USD'))
      end

      def possible_variants_count
        3
      end

      def catalog_links_as_json
        {'omg' => 'wtf'}
      end
    end

    let(:product) {
      mock("Product Record",
           :id          => 9001,
           :category_id => 800,
           :name        => "Worship",
           :photos      => [photo],
           :msrp        => stub(:cents => 300, :currency => stub(:iso_code => 'USD')),
           :buying?     => true)
    }
    
    let(:photo) {
      mock("Photo", :position => 1)
    }

    let(:options) { {} }

    let(:presenter) {  TestProductPresenter.new(product, options) }

    subject { presenter }

    it "aliases to_hash to as_json" do
      subject.to_hash.should == subject.as_json
    end

    context "as_json" do
      subject { presenter.as_json['product'] }

      it "has a name" do
        subject['name'].should == 'Worship'
      end

      it "has a possible_variants_count" do
        subject['possible_variants_count'].should == 3
      end

      it "has a catalog_links" do
        subject['catalog_links'].should == {'omg' => 'wtf'}
      end

      it "has an msrp as money" do
        subject['msrp'].should == {
          'money' => {
            'cents'    => 300,
            'currency' => 'USD'
          }
        }
      end

      it "has a min sell price as money" do
        subject['min_sell_price'].should == {
          'money' => {
            'cents'    => 499,
            'currency' => 'USD'
          }
        }
      end

      it "has an id" do
        subject['id'].should == 9001
      end

      it "has the buyingness" do
        subject['is_buying'].should == true
      end


      it "has api _links" do
        subject['_links'].should == {
          'self' => { :href => "/v1/products/9001" },
          'related_products' => { :href => "/v1/products/9001/related" },
          'category' => { :href => '/v1/categories/800'}
        }
      end

      it "does not embed" do
        subject.should_not have_key('_embedded')
      end

      context "embedding of photos enabled" do
        let(:options) { {:embedded => [:photos]} }

        it "has embedded photos" do
          subject['_embedded']['photos'].should == [
            {
              'photo' => {
                'position' => 1
              }
            }
          ]
        end
      end

      context "always renders nil attributes" do
        before(:each) do
          product.stub(:name).and_return(nil)
        end

        it "has a null name" do
          subject.fetch('name').should == nil
        end
      end
    end
  end
end
