require 'spec_helper'
require 'roar_extensions'

module RoarExtensions
  describe MoneyPresenter do
    let(:currency) { stub(:iso_code => "USD") }
    let(:money)    { stub(:currency => currency, :cents => 100) }

    subject { MoneyPresenter.new(money) }

    it "has cents" do
      subject.to_hash['money']['cents'].should == 100
    end

    it "has currency" do
      subject.to_hash['money']['currency'].should == "USD"
    end
  end
end
