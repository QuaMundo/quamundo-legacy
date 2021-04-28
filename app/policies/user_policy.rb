# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  pre_check :admin?

  def new?
    user.admin?
  end

  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  private

  def admin?
    deny! if user.blank?
  end
end
