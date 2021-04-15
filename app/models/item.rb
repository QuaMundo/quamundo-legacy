# frozen_string_literal: true

class Item < ApplicationRecord
  include WorldInventory
  include Factable
end
