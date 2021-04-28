# frozen_string_literal: true

module TagsParams
  extend ActiveSupport::Concern
  def dispatch_tags_param!(param)
    return if param.blank?

    tagset = param[:tagset] || ''
    param[:tagset] = tagset.split(',').map(&:strip).uniq.select(&:present?)
  end
end
