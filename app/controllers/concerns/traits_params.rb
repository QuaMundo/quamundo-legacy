module TraitsParams
  extend ActiveSupport::Concern

  def dispatch_traits_param!(p)
    if p.present? && p.has_key?(:attributeset)
      attributes = p[:attributeset]
      p[:attributeset] = collect_attributes(attributes)
    end
  end

  private
  def collect_attributes(attributes)
    keys = attributes[:key].values
    values =  attributes[:value].values
    Hash[keys.zip(values)].reject { |k, _| k.nil? || k.empty? }
  end
end
