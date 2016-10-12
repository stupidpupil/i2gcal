class CatToColFilter

  def initialize(mapping)
    @mapping = mapping
  end

  def call(ical_event, representation)
    @mapping.each_pair do |cat, col|
      representation['colorId'] = col.to_s if ical_event.categories.flatten.any? {|c| c.to_sym == cat}
    end
    representation
  end

end