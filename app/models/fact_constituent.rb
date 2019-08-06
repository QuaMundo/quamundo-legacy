class FactConstituent < ApplicationRecord
  belongs_to :fact, touch: true
  belongs_to :constituable, polymorphic: true

  before_validation :normalize_roles

  validates :fact_id,
    uniqueness: { scope: [:constituable_type, :constituable_id] }
  validate :allowed_constituable_type

  # FIXME: Missing specs for these scopes
  # scope :items,     -> { where(constituable_type: 'Item') }
  # scope :figures,   -> { where(constituable_type: 'Figure') }
  # scope :locations, -> { where(constituable_type: 'Location') }
  # scope :concepts,  -> { where(constituable_type: 'Concept') }

  private
  def allowed_constituable_type
    unless %w(Item Figure Location Concept).include?(constituable_type)
      errors.add(:constituable_type, 'Facts not allowed to contain facts')
    end
  end

  def normalize_roles
    self.roles ||=  []
  end
end
