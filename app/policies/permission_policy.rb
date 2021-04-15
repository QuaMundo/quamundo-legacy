# frozen_string_literal: true

class PermissionPolicy < ApplicationPolicy
  def update?
    owner?
  end

  private

  def owner?
    context_satisfied? && (user.id == world.user.id)
  end

  def context_satisfied?
    user.present? && world.present?
  end
end
