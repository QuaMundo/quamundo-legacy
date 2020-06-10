module TagsParams
  extend ActiveSupport::Concern
  def dispatch_tags_param!(p)
    if p.present?
      tagset = p[:tagset] || ''
      p[:tagset] = tagset.split(',').map(&:strip).uniq.select(&:present?)
    end
  end
end
