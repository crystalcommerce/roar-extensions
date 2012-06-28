require 'spec_helper'
require "roar_extensions"

module RoarExtensions
  describe PaginatedCollectionPresenter do
    let(:current_page)  { 1 }
    let(:next_page)     { 2 }
    let(:previous_page) { nil }
    let(:paginated_result) do
      mock("Paginated Result", :total_pages => 3,
                               :current_page => current_page,
                               :next_page => next_page,
                               :previous_page => previous_page,
                               :total_entries => 3,
                               :collect => %w[A],
                               :per_page => 1)
    end
    let(:base_path) { "/things" }

    describe "#as_json" do
      let(:presenter)  { PaginatedCollectionPresenter.new(paginated_result, base_path)}
      subject { presenter.as_json['paginated_collection'] }

      it "includes the total pages" do
        subject['total_pages'].should == 3
      end

      it "includes the total entries" do
        subject['total_entries'].should == 3
      end

      it "includes the per page" do
        subject['per_page'].should == 1
      end

      it "includes the self link" do
        subject['_links']['self'].should == {:href => "/things"}
      end

      it "includes the next_page link" do
        subject['_links']['next_page'].should == {:href => "/things?page=2"}
      end

      it "does not include the previous_page link on the first page" do
        subject['_links'].should_not have_key('previous_page')
      end

      it "includes the paginated results under the entries key" do
        subject['entries'].should == ['A']
      end

      it "includes current_page" do
        subject["current_page"].should == 1
      end

      it "includes next_page" do
        subject["next_page"].should == 2
      end

      it "includes previous_page" do
        subject["previous_page"].should == nil
      end

      context "on last page" do
        let(:previous_page) { 2 }
        let(:current_page)  { 3 }
        let(:next_page)     { nil }

        it "includes the self link" do
          subject['_links']['self'].should == {:href => "/things?page=3"}
        end

        it "does not include the next_page link" do
          subject['_links'].should_not have_key('next_page')
        end

        it "includes the previous_page link" do
          subject['_links']['previous_page'].should == {:href => "/things?page=2"}
        end

        it "includes current_page" do
          subject["current_page"].should == 3
        end

        it "includes next_page" do
          subject["next_page"].should == nil
        end

        it "includes previous_page" do
          subject["previous_page"].should == 2
        end
      end

      context "middle page" do
        let(:previous_page) { 1 }
        let(:current_page)  { 2 }
        let(:next_page)     { 3 }

        it "includes the self link" do
          subject['_links']['self'].should == {:href => "/things?page=2"}
        end

        it "includes the next_page link" do
          subject['_links']['next_page'].should == {:href => "/things?page=3"}
        end

        it "includes the previous_page link" do
          subject['_links']['previous_page'].should == {:href => "/things"}
        end

        it "includes current_page" do
          subject["current_page"].should == 2
        end

        it "includes next_page" do
          subject["next_page"].should == 3
        end

        it "includes previous_page" do
          subject["previous_page"].should == 1
        end
      end
    end
  end
end
