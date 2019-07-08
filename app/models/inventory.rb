class Inventory < ApplicationRecord
  belongs_to :user
  belongs_to :world
  belongs_to :inventory, polymorphic: true

  # this is a read-only model!
  def readonly?
    true
  end
end
