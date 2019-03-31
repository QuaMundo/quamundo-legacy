module Imaged
  extend ActiveSupport::Concern

  included do
    validate :only_image_attachments
    before_destroy :purge_image
    has_one_attached :image
  end

  def only_image_attachments
    if image.attached? && !image.image?
      # FIXME: I18n
      errors.add(:image, 'Only images may be attached!')
    end
  end

  def purge_image
    if image.attached?
      image.purge
    end
  end
end
