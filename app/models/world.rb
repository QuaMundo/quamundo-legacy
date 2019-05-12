class World < ApplicationRecord
  include Imaged
  include Slugged
  include Noteable
  include Tagable

  belongs_to :user
  has_many :dashboard_entries
  with_options dependent: :destroy do |assoc|
    assoc.has_many :figures
    assoc.has_many :items
    assoc.has_many :locations
  end
end
