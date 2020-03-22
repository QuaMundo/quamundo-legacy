class RegistrationPolicy < ApplicationPolicy
  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.present?
  end

  def update?
    user.present?
  end

  def destroy?
    !user.admin?
  end

  def cancel?
    user.present?
  end
end
