class FactConstituent < ApplicationRecord
  belongs_to :fact, touch: true
  belongs_to :constituable, polymorphic: true

  has_many :relation_constituents, dependent: :destroy
  has_many :relatives, through: :relation_constituents

  attr_readonly :constituable

  before_validation :normalize_roles

  validates :fact_id,
    uniqueness: { scope: [:constituable_type, :constituable_id] }
  validate :allowed_constituable_type
  validate :common_world, on: :create

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

  def common_world
    unless constituable.present? && constituable.world == fact.world
      errors.add(:constituable, I18n.t('constituent_common_world'))
    end
  end

  def normalize_roles
    self.roles ||=  []
  end
end
