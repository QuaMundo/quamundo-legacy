class World < ApplicationRecord
  include Imaged
  include Slugged
  include Noteable
  include Tagable
  include Traitable
  include Dossierable

  belongs_to :user
  has_many :inventories

  # FIXME: Can this put in a concern?
  with_options dependent: :destroy do |assoc|
    assoc.has_many :figures
    assoc.has_many :items
    assoc.has_many :locations
    assoc.has_many :concepts
    assoc.has_many :facts
  end

  alias_attribute :name, :title
end
