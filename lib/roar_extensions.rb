require "roar_extensions/version"
require "representable"
require "representable/json"
require "roar"
require 'roar/representer/json'
require 'roar/representer/json/hal'

module RoarExtensions
  def self.base_url=(url)
    @base_url = url
  end

  def self.base_url
    @base_url || raise("Set base url like RoarExtensions.base_url = 'http://example.com'")
  end
end

require 'active_support'
require 'active_support/core_ext/module'
require 'active_support/core_ext/hash/keys'

require 'roar_extensions/helpers/embedded_parameter_parsing'
require 'roar_extensions/json_hal_extensions'
require 'roar_extensions/representable_json_extensions'
require 'roar_extensions/representer'
require 'roar_extensions/presenter'
require 'roar_extensions/destroyed_record_presenter'
require 'roar_extensions/link_presenter'
require 'roar_extensions/money_presenter'
require 'roar_extensions/paginated_collection_presenter'
require 'roar_extensions/resource_links'
require 'roar_extensions/hypermedia_extensions'
