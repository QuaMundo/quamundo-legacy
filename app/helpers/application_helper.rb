module ApplicationHelper
  # Element ID helper - creates ids for html elements
  def element_id(obj, prefix = nil)
    [prefix, obj.model_name.param_key, obj.id].compact.join('-')
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
