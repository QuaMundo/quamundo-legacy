module ImageHelper
  # Simplify url/path generation for attached images
  # FIXME: Should ensure null or both args are provided
  def attached_img_path(attached, x = 800, y = 600)
    return '' unless attached.image?
    begin
      url_for(attached.variant(resize_to_fill: [x, y]).processed)
    rescue
      ''
    end
  end

  # Get image variant path for overview cards
  def card_img_path(attached)
    return '' unless attached.image?
    url_for(attached)
  end
end
