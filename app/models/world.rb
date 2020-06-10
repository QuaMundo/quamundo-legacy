class World < ApplicationRecord
  include Imaged
  include Slugged
  include Noteable
  include Tagable
  include Traitable
  include Dossierable

  belongs_to :user, inverse_of: :worlds
  has_many :inventories
  has_many :permissions, dependent: :destroy

  accepts_nested_attributes_for :permissions,
    update_only: true,
    allow_destroy: true,
    reject_if: ->(attr) { attr[:permissions].blank? }

  # FIXME: Can this put in a concern?
  with_options dependent: :destroy do |assoc|
    assoc.has_many :figures
    assoc.has_many :items
    assoc.has_many :locations
    assoc.has_many :concepts
    assoc.has_many :facts
  end

  # FIXME: This should go to a helper
  # Calculate world dates
  def beginning
    world_age.begin_of_world
  end

  def ending
    world_age.end_of_world
  end

  def age
    world_age.age_of_world
  end
  
  private
  WORLD_AGE_SQL = <<~SQL
    WITH fact_dates AS (
      SELECT
        -- w.*,
        w.id AS world_id,
        -- w.name,
        CASE
          WHEN MIN(f.start_date) IS NULL THEN MIN(f.end_date)
          WHEN MIN(f.start_date) > MIN(f.end_date) THEN MIN(f.end_date)
          ELSE MIN(f.start_date)
        END AS begin_of_world,
        CASE
          WHEN MAX(f.end_date) IS NULL THEN MAX(f.start_date)
          WHEN MAX(f.end_date) < MAX(f.start_date) THEN MAX(f.start_date)
          ELSE MAX(f.end_date)
        END AS end_of_world
      FROM worlds w
      LEFT OUTER JOIN facts f ON w.id = f.world_id
      GROUP BY w.id
      HAVING w.id = :world_id
    )
    SELECT
      f.*,
      CASE
        WHEN f.begin_of_world IS NULL OR f.end_of_world IS NULL THEN NULL
        WHEN f.begin_of_world = f.end_of_world THEN NULL
        ELSE f.end_of_world - f.begin_of_world
      END AS age_of_world
    FROM fact_dates f
  SQL

  def world_age
    @age ||= World.find_by_sql([WORLD_AGE_SQL, { world_id: id }]).first
  end
end
