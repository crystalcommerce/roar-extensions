require 'spec_helper'
require 'roar_extensions'

module RoarExtensions
  describe LinkPresenter do
    subject { LinkPresenter.new('search_engine', 'http://google.com') }

    describe "#==" do
      it "returns true if href, rel, and title match" do
        subject.should == LinkPresenter.new('search_engine', 'http://google.com')
      end

      it "returns false if href, rel, or title differ" do
        subject.should_not == LinkPresenter.new('search_engine', 'http://bing.com')
        subject.should_not == LinkPresenter.new('weee', 'http://google.com')
        subject.should_not == LinkPresenter.new('search_engine', 'http://google.com', 'cows')
      end
    end

    context "no title" do
      its(:as_json) do
        should == { 'search_engine' => {'href' => 'http://google.com'} }
      end

      it "aliases to_hash to as_json" do
        subject.to_hash.should == subject.as_json
      end
    end

    context "title given" do
      subject { LinkPresenter.new('search_engine',
                                  'http://google.com',
                                  'Cool Search') }
      its(:as_json) do
        should == {
          'search_engine' => {
            'href'  => 'http://google.com',
            'title' => 'Cool Search'
          }
        }
      end

      it "aliases to_hash to as_json" do
        subject.to_hash.should == subject.as_json
      end
    end
  end
end
