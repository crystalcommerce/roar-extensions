require 'spec_helper'
require 'roar_extensions'

module RoarExtensions
  describe DestroyedRecordPresenter do
    class DestroyedRecordPresenterTest
      include DestroyedRecordPresenter
      root_element :foo
    end

    subject { DestroyedRecordPresenterTest.new(123) }

    it "has just the id" do
      subject.to_hash.should == {'foo' => {'id' => 123}}
    end
  end
end
