class World < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, :user, presence: true
  validate :only_image_attachments
  # FIXME: Which is better :before- or :after_destroy?
  after_destroy :purge_image

  private
  def only_image_attachments
    if image.attached? && !image.image?
      errors.add(:image, 'Only images may be attached!')
    end
  end

  def purge_image
    if image.attached?
      image.purge
    end
  end
end
