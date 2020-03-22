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
    deny! unless user.present?
  end
end
