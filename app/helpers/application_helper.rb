module ApplicationHelper
  # Element ID helper - creates ids for html elements
  def element_id(obj, prefix = nil)
    [prefix, obj.model_name.param_key, obj.id].compact.join('-')
  end

  # Create a link to facts of an inventory object by adding params
  # inventory: { :id, :type }
  def inventory_facts_path(obj, format: :html)
    world_facts_path(obj.world, inventory: {
      id: obj.id,
      type: obj.model_name.name
    }, format: format)
  end

  # Create a link to locations belonging to a fact by adding params
  # fact: fact_id
  # FIXME: Refactor naming of method
  def locations_by_fact_path(world, fact: nil, format: :html)
    if fact.nil?
      world_locations_path(world, format: format)
    else
      world_locations_path(world, fact: fact, format: format)
    end
  end

  # LonLat helper - gets coords as string from rgeo object (to prefill input)
  def get_lonlat(lonlat)
    lonlat ? "#{lonlat.lat.to_s}, #{lonlat.lon.to_s}" : ''
  end

  # A Markdown helper to render markdown text fields
  def markdown(text)
    return '' unless text.present?
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      tables: true,
      underline: true,
      highlight: true
    )
    @markdown.render(text).html_safe
  end
end
