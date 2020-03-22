class Permission < ApplicationRecord
  validates :world, presence: true
  validates :world_id, uniqueness: { scope: :user_id }
  validate :not_owner

  belongs_to :world
  belongs_to :user, optional: true

  private
  # FIXME: Seems to be redundant to `validates :world, presence: true`
  def not_owner
    unless world.try(:user) && (world.user != user)
      errors.add(:user, I18n.t('.not_allowed_owner'))
    end
  end
end
