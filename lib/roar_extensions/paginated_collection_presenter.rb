module RoarExtensions
  class PaginatedCollectionPresenter
    include RoarExtensions::Presenter

    root_element :paginated_collection

    collection :entries, :from => :record
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
  end
end
