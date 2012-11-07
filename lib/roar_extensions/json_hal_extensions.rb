module Roar::Representer::JSON::HAL::Resources
  def compile_fragment(bin, doc)
    return super unless bin.options[:embedded]
    super(bin, doc["_embedded"] ||= {})
  end
end
