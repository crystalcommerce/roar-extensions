class RoarExtensions::LinkPresenter
  attr_reader :href, :rel, :title

  def initialize(rel, href, title = nil)
    @href  = href
    @rel   = rel
    @title = title
  end

  def ==(other)
    href  == other.href && 
    rel   == other.rel && 
    title == other.title
  end

  def to_hash(*args)
    {
      rel => {
        :href => href,
        :title => title
      }.delete_if {|k,v| v.nil? || v.empty?}
    }
  end

  alias :as_json :to_hash
end
