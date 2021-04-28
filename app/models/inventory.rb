# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :world, inverse_of: :inventories
  belongs_to :inventory, polymorphic: true

  # this is a read-only model!
  def readonly?
    true
  end

  # FIXME: Turn this to a common helper available to all Models
  # custom id is <inventory_type>.<inventory_id>
  def type_id
    "#{inventory_type}.#{inventory_id}"
  end

  # in case one wants to refresh the materialized view
  def self.refresh
    connection
      .execute('REFRESH MATERIALIZED VIEW inventories;')
  end
end
