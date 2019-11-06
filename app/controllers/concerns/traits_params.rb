module TraitsParams
  extend ActiveSupport::Concern

  # FIXME: Refactor: Split function
  def dispatch_traits_param!(p)
    return unless p.present?
    if p[:trait].key?(:new_key) && p[:trait][:new_value]
      key = p[:trait].delete(:new_key)
      value = p[:trait].delete(:new_value)
      p.delete(:trait)
      unless key.nil? || key.empty? || value.nil?
        p[:attributeset] ||= {}
        p[:attributeset]
          .merge!({ key.to_sym => value })
          .reject! { |_, v| v.to_s.empty? }
      end
    end
  end
end
