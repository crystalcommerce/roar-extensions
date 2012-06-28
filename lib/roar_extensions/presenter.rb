require 'roar/representer/json'
require 'roar/representer/json/hal'

module RoarExtensions::Presenter

  module ConditionalEmbeds
    def skip_property?(bin, options)
      if bin.definition.options[:embedded]
        super || !embed_property?(bin.definition)
      else
        super
      end
    end

    def embed_property?(definition)
      (@embedded & [definition.name.to_sym, definition.from.to_sym]).present?
    end
  end

  def initialize(record)
    @record = record
    @embedded ||= []
  end

  def self.included(base)
    base.send(:include, Roar::Representer::JSON::HAL)
    base.send(:include, ConditionalEmbeds)
    base.extend(RoarExtensions::Representer)

    base.class_eval do
      alias :as_json :to_hash

      def self.delegated_property(name, options = {})
        if from = options.delete(:from)
          define_method(name) do
            record.send(from)
          end
        else
          delegate name, :to => :record, :allow_nil => true
        end

        property name, options
      end


      def self.delegated_collection(name, options ={})
        if from = options.delete(:from)
          define_method(name) do
            record.send(from)
          end
        else
          delegate name, :to => :record, :allow_nil => true
        end

        collection name, options
      end

    end
  end

private
  def record
    @record
  end
end
