class FactConstituent < ApplicationRecord
  belongs_to :fact, touch: true
  belongs_to :constituable, polymorphic: true

  before_validation :normalize_roles

  validates :fact_id,
    uniqueness: { scope: [:constituable_type, :constituable_id] }
  validate :allowed_constituable_type

  # scope :items,     -> { where(constituable_type: 'Item') }
  # scope :figures,   -> { where(constituable_type: 'Figure') }
  # scope :locations, -> { where(constituable_type: 'Location') }

  private
  def allowed_constituable_type
    unless %w(Item Figure Location Spirit).include?(constituable_type)
      errors.add(:constituable_type, 'Facts not allowed to contain facts')
    end
  end

  def normalize_roles
    self.roles = [] if self.roles.nil?
  end
end
