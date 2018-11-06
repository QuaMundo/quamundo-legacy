module ApplicationHelper
  # Element ID helper - creates ids for html elements
  def element_id(obj, prefix = nil)
    [prefix, obj.class.to_s.downcase, obj.id].reject(&:nil?).join('-')
  end

  # Simplify url/path generation for attached images
  def attached_img_path(attached, options = {})
    return '' unless attached.image?
    url_for(attached.variant(options).processed)
  end

  # Get image variant path for overview cards
  def overview_img_path(attached)
    return '' unless attached.image?
    options = {
      resize: "320x240^",
      gravity: "center",
      crop: "320x240+0+0"
    }
    attached_img_path(attached, combine_options: options)
  end
end
