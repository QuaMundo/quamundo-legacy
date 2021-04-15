# frozen_string_literal: true

class Permission < ApplicationRecord
  validates :world, :permissions, presence: true
  validates :world_id, uniqueness: { scope: :user_id }
  validate :not_owner

  belongs_to :world
  belongs_to :user, optional: true

  private

  # FIXME: Seems to be redundant to `validates :world, presence: true`
  def not_owner
    errors.add(:user, I18n.t('.not_allowed_owner')) unless world.try(:user) && (world.user != user)
  end
end
