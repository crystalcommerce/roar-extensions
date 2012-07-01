module Representable
  module JSON
    alias_method :original_to_hash, :to_hash

    def to_hash(options = {})
      if options.has_key?(:include)
        options[:include].map!(&:to_sym)
        options[:include] |= self.class.always_include_attributes.map(&:to_sym)
      end
      original_to_hash(options)
    end
  end
end
