module RoarExtensions
  class PaginatedCollectionPresenter
    include RoarExtensions::Presenter

    root_element :paginated_collection

    delegated_property :per_page
    delegated_property :total_pages
    delegated_property :total_entries
    delegated_property :current_page
    delegated_property :next_page
    delegated_property :previous_page

    link(:rel => "self")          { page_link(record.current_page) }
    link(:rel => "next_page")     { page_link(record.next_page) }
    link(:rel => "previous_page") { page_link(record.previous_page) }

    def initialize(record, base_path)
      super(record)
      @base_path = base_path
    end

    def page_link(page_number)
      if page_number == 1
        @base_path
      elsif !page_number.nil?
        "#{@base_path}?page=#{page_number}"
      end
    end

    alias_method :to_hash_without_entries, :to_hash

    # Hack to push the :include and :exclude options to the collection results
    def to_hash(options = {})
      opt_include = options.delete(:include)
      opt_exclude = options.delete(:exclude)
      res = to_hash_without_entries(options)
      res["paginated_collection"]["entries"] = record.collect.
        map {|e| e.to_hash(options.merge(:include => opt_include,
                                         :exclude => opt_exclude))}
      res
    end
  end
end
