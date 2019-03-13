class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  validate :nick, :nick_normalized?, if: :has_nick?
  validate :only_image_attachments, if: :has_image?
  validates :title, :user, presence: true, if: :has_title?
  validates_uniqueness_of :title, case_sensitive: false, if: :has_title?
  validates_uniqueness_of :nick, case_sensitive: false, if: :has_nick?

  before_destroy :purge_image, if: :has_image?
  before_save { nick.downcase! if has_nick? }

  scope :last_updated, ->(limit = 4) { order(updated_at: :desc).limit(limit) }

  protected
  def has_title?
    respond_to? :title
  end

  def has_nick?
    respond_to? :nick
  end

  def has_image?
    respond_to? :image
  end

  def nick_normalized?
    unless nick =~ %r{^[a-zA-Z0-9][a-zA-Z0-9\.\-_]*[a-zA-Z0-9]$}
      errors.add(:nick, I18n.t('nick_normalized'))
    end
  end

  def only_image_attachments
    return unless has_image?
    if image.attached? && !image.image?
      # FIXME: I18n
      errors.add(:image, 'Only images may be attached!')
    end
  end

  def purge_image
    return unless has_image?
    if image.attached?
      image.purge
    end
  end
end
