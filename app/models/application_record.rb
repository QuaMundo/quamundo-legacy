class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :last_updated, ->(limit = 4) { order(updated_at: :desc).limit(limit) }
end
