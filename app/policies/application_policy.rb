# frozen_string_literal: true

# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  # Configure additional authorization contexts here
  # (`user` is added by default).
  #
  #   authorize :account, optional: true
  #
  # Read more about authoriztion context:
  # https://actionpolicy.evilmartians.io/#/authorization_context
  authorize :user, allow_nil: true, optional: true
  authorize :world, allow_nil: true, optional: true
  authorize :fact, allow_nil: true, optional: true

  alias_rule :edit?, :create?, :destroy?, to: :update?

  private

  # Define shared methods useful for most policies.
  # For example:
  #
  #  def owner?
  #    record.user_id == user.id
  #  end
  def owner?
    world.user_id == user.id
  end
end
