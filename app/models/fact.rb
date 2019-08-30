class Fact < ApplicationRecord
  include WorldInventory

  has_many :fact_constituents, dependent: :destroy

  has_many :items, through: :fact_constituents,
    source: :constituable, source_type: 'Item'
  has_many :figures, through: :fact_constituents,
    source: :constituable, source_type: 'Figure'
  has_many :locations, through: :fact_constituents,
    source: :constituable, source_type: 'Location'
  has_many :concepts, through: :fact_constituents,
    source: :constituable, source_type: 'Concept'

  has_many :relations, dependent: :destroy

  validate :end_after_start_date

  scope :chronological, -> {
    order("start_date ASC NULLS FIRST, end_date DESC NULLS FIRST")
  }

  private
  def end_after_start_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, I18n.t('.end_before_start_date'))
    end
  end
end
