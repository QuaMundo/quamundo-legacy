# frozen_string_literal: true

module ImageHelper
  # Simplify url/path generation for attached images
  # FIXME: Should ensure null or both args are provided
  def attached_img_path(attached, width = 800, height = 600)
    return '' unless attached.image?

    begin
      url_for(attached.variant(resize_to_fill: [width, height]).processed)
    rescue StandardError
      ''
    end
  end

  # Get image variant path for overview cards
  def card_img_path(attached)
    return '' unless attached.image?

    url_for(attached)
  end
end
