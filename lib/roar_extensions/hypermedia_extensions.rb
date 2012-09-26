module RoarExtensions::HypermediaExtensions
  def marshal_dump
    super.stringify_keys
  end
end

Roar::Representer::Feature::Hypermedia::Hyperlink.send(:include, RoarExtensions::HypermediaExtensions)
