# frozen_string_literal: true

module TraitsParams
  extend ActiveSupport::Concern

  def dispatch_traits_param!(param)
    return unless param.present? && param.key?(:attributeset)

    attributes = param[:attributeset]
    param[:attributeset] = collect_attributes(attributes)
  end

  private

  def collect_attributes(attributes)
    keys = attributes[:key].values
    values = attributes[:value].values
    Hash[keys.zip(values)].reject { |k, _| k.blank? }
  end
end
