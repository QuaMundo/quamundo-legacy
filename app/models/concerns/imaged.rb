# frozen_string_literal: true

module Imaged
  extend ActiveSupport::Concern

  included do
    validate :only_image_attachments
    before_destroy :purge_image
    has_one_attached :image
  end

  def only_image_attachments
    return unless image.attached? && !image.image?

    # FIXME: I18n
    errors.add(:image, 'Only images may be attached!')
  end

  def purge_image
    image.purge if image.attached?
  end
end
