module Factable
  extend ActiveSupport::Concern

  included do
    has_many :fact_constituents, as: :constituable, dependent: :destroy
    has_many :facts, through: :fact_constituents
  end
end
