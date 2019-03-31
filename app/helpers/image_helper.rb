module ImageHelper
  # Simplify url/path generation for attached images
  def attached_img_path(attached, options = {})
    return '' unless attached.image?
    url_for(attached.variant(options).processed)
  end

  # Get image variant path for overview cards
  def card_img_path(attached)
    return '' unless attached.image?
    options = {
      resize: "320x240^",
      gravity: "center"
    }
    attached_img_path(attached, combine_options: options)
  end
end
