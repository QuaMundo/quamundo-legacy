# frozen_string_literal: true

module FactConstituentsParams
  extend ActiveSupport::Concern

  def dispatch_constituent_roles!(param)
    dispatch_roles!(param)
  end

  def dispatch_fact_constituents_param!(param)
    param&.each do |_, constituent|
      dispatch_roles!(constituent)
      strip_inventory_param!(constituent)
    end
  end

  def strip_inventory_param!(param)
    return if param[:constituable].blank?

    # FIXME: This is not clean - refactor!
    # Param `inventory` is only for auxiliary purposes - it's a string including
    # inventory type and id
    c_type, c_id = param.delete(:constituable).split('.')
    param[:constituable_id] = c_id
    param[:constituable_type] = c_type
  end

  private

  def dispatch_roles!(param)
    if param[:roles].present? &&
       param[:roles].is_a?(String)

      roles = param[:roles]
      param[:roles] = roles.split(',').map(&:strip).uniq
    else
      param[:roles] = []
    end
  end
end
