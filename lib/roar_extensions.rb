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

require "roar_extensions/json_hal_extensions"
