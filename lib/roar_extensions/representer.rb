module RoarExtensions::Representer
  def root_element(element)
    self.representation_wrap = element.to_s
  end

  # In the real API, :from and name are backwards?
  def property(name, options = {})
    options.merge!(:include_nil => true)

    if create_object = options.delete(:as)
      define_method("#{name}_presented") do
        attr_value = send(name)
        attr_value && create_object.new(attr_value).as_json
      end

      options[:from] = "#{name}_presented"
    end

    if from = options.delete(:from)
      super(from, options.merge(:from => name))
    else
      super(name, options)
    end
  end

  def collection(name, options = {})
    if create_object = options.delete(:as)
      define_method("#{name}_presented") do
        send(name).map do |element|
          element && create_object.new(element).as_json
        end
      end
      options[:from] = "#{name}_presented"
    end

    super name, options
  end

  def link(name, &block)
    development = (defined?(Rails) && Rails.env.development?) ||
                  ENV['RAILS_ENV']   == 'development' ||
                  ENV['ENVIRONMENT'] == 'development'
    if development
      super(name) do
        if path = instance_exec(&block)
          "#{RoarExtensions.base_url}#{path}"
        end
      end
    else
      super
    end
  end
end
