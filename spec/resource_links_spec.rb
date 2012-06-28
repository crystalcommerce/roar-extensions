require 'spec_helper'
require 'roar_extensions'

module RoarExtensions
  describe ResourceLinks do
    class TestResourceLinks
      include ResourceLinks

      def test_merge_links(styles)
        merge_links(styles) { |style|
          {style => 'foo'}
        }
      end

      def test_resource_link_json(h)
        resource_link_json(h)
      end
    end

    subject { TestResourceLinks.new }

    describe "#merge_links" do
      it "merges all hashes for the list using the block as a builder" do
        subject.test_merge_links(['a', 'b']).
          should == {
            'a' => 'foo',
            'b' => 'foo'
          }
      end
    end

    describe "#resource_link_json" do
      it "turns a hash with keys as rels into proper link representations" do
        subject.test_resource_link_json('self' => '/foo', 'next' => '/bar').
          should == {
            'self' => { 'href' => '/foo' },
            'next' => { 'href' => '/bar' }
          }
      end
    end
  end
end
