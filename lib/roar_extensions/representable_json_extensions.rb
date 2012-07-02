module Representable
  module JSON
    alias_method :to_hash_without_always_include_attributes, :to_hash

    def to_hash(options = {})
      if options[:include]
        options[:include].map!(&:to_sym)
        options[:include] |= self.class.always_include_attributes.map(&:to_sym)
      end
      to_hash_without_always_include_attributes(options)
    end
  end
end
