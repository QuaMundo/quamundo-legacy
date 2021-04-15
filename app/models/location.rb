# frozen_string_literal: true

class Location < ApplicationRecord
  include WorldInventory
  include Factable

  scope :with_coords, -> { where.not(lonlat: nil) }

  def lon
    lonlat.try(:lon)
  end

  def lat
    lonlat.try(:lat)
  end
end
