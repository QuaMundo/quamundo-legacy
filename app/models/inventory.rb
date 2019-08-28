class Inventory < ApplicationRecord
  belongs_to :user
  belongs_to :world
  belongs_to :inventory, polymorphic: true

  # this is a read-only model!
  def readonly?
    true
  end

  # in case one wants to refresh the materialized view
  def self.refresh
    connection
      .execute('REFRESH MATERIALIZED VIEW inventories;')
  end
end
