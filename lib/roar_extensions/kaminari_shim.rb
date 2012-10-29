module RoarExtensions
  class KaminariShim < SimpleDelegator
    def per_page
      limit_value
    end

    def next_page
      last_page? ? nil : current_page + 1
    end

    def previous_page
      first_page? ? nil : current_page - 1
    end

    def total_pages
      num_pages
    end

    def total_entries
      total_count
    end
  end
end
