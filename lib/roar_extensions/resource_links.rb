module RoarExtensions
  module ResourceLinks
  private
    def merge_links(collection, &presenter_generator)
      collection.inject({}) do |acc, element|
        acc.merge(presenter_generator.call(element).to_hash)
      end
    end

    def resource_link_json(link_hash)
      link_hash.inject({}) do |acc, (rel, href)|
        acc.merge(LinkPresenter.new(rel, href).to_hash)
      end
    end
  end
end
