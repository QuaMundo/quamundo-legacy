class DashboardEntry < ApplicationRecord
  belongs_to :user
  belongs_to :world
  belongs_to :inventory, polymorphic: true

  default_scope { limit 15 }

  # this is a read-only model!
  def readonly?
    true
  end
end
