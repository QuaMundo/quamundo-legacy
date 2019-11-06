module FactConstituentsParams
  extend ActiveSupport::Concern

  def dispatch_constituent_roles!(p)
    dispatch_roles!(p)
  end

  def dispatch_fact_constituents_param!(p)
    p.each do |_, constituent|
      dispatch_roles!(constituent)
      strip_inventory_param!(constituent)
    end
  end

  def strip_inventory_param!(p)
    # FIXME: This is not clean - refactor!
    # Param `inventory` is only for auxiliary purposes - it's a string including
    # inventory type and id
    c_type, c_id = p.delete(:constituable).split('.')
    p[:constituable_id] = c_id
    p[:constituable_type] = c_type
  end

  private
  def dispatch_roles!(p)
    if p[:roles].present? &&
        p[:roles].kind_of?(String)

      roles = p[:roles]
      p[:roles] = roles.split(',').map(&:strip).uniq
    else
      p[:roles] = []
    end
  end
end
