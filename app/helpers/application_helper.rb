module ApplicationHelper
  # Element ID helper - creates ids for html elements
  def element_id(obj, prefix = nil)
    [prefix, obj.class.to_s.downcase, obj.id].reject(&:nil?).join('-')
  end

  # LonLat helper - gets coords as string from rgeo object (to prefill input)
  def get_lonlat(lonlat)
    lonlat ? "#{lonlat.lat.to_s}, #{lonlat.lon.to_s}" : ''
  end
end
