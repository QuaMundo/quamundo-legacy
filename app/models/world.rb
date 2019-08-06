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

  # FIXME: REFACTOR: Get this with a single query from db
  def begin_of_time
    @begin_of_time ||= self.facts.minimum(:start_date)
  end

  def end_of_time
    @end_of_time ||= self.facts.maximum(:end_date)
  end

  def age
    unless begin_of_time.nil? || end_of_time.nil?
      end_of_time - begin_of_time
    end
  end
end
