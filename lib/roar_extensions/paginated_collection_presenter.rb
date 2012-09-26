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
      res["paginated_collection"]["entries"] = record.collect.map do |e|
        entry_include = opt_include && opt_include.map {|name| get_actual_property_name(e, name)}
        entry_exclude = opt_exclude && opt_exclude.map {|name| get_actual_property_name(e, name)}
        e.to_hash(options.merge(:include => entry_include,
                                :exclude => entry_exclude))
      end
      res
    end

  private
    def get_actual_property_name(entry, aliased_name)
      if attr = entry.send(:representable_attrs).
                      detect {|a| a.options[:from].to_s == aliased_name.to_s}
        attr.name
      else
        aliased_name
      end
    end
  end
end
