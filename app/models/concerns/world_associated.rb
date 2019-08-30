module WorldAssociated
  extend ActiveSupport::Concern

  included do
    belongs_to :world, touch: true
    has_one :user, through: :world
    has_one :dashboard_entry, as: :inventory

    attr_readonly :world_id
  end
end
