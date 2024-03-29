# frozen_string_literal: true

class WorldPolicy < ApplicationPolicy
  pre_check :allow_owner, only: %i[
    edit? update? show? destroy? set_permissions?
  ]

  def new?
    user_present?
  end

  def create?
    user_present?
  end

  def edit?
    rw?
  end

  def update?
    rw?
  end

  def show?
    r? || pr?
  end

  def index?
    # FIXME: Refactor - performance!?
    record.all? do |world|
      world.user_id == user.try(:id) ||
        world.permissions.any? { |p| p.permissions == 'public' } ||
        world.permissions.any? { |p| p.user == user }
    end
  end

  def destroy?
    false
  end

  def set_permissions?
    false
  end

  private

  def owner?
    user.nil? ? false : (record.user.id == user.id)
  end

  def user_present?
    user.present?
  end

  def allow_owner
    allow! if owner?
  end

  # FIXME: Refactor - seems to do 2 db req with pr?
  def r?
    if record.nil?
      false
    else
      record
        .permissions
        .where(permissions: %i[r rw], user: user)
        .exists?
    end
  end

  def rw?
    if record.nil?
      false
    else
      record
        .permissions
        .where(permissions: :rw, user: user)
        .exists?
    end
  end

  # FIXME: Refactor - seems to do 2 db req with r?
  def pr?
    if record.nil?
      false
    else
      record
        .permissions
        .where(permissions: :public)
        .exists?
    end
  end
end
