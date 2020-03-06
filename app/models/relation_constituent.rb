class RelationConstituent < ApplicationRecord
  belongs_to :fact_constituent, inverse_of: :relation_constituents
  belongs_to :relation, inverse_of: :relation_constituents

  has_one :fact, through: :relation

  has_many :relatives,
    foreign_key: :subject_id,
    class_name: 'SubjectRelativeRelation'

  attr_readonly :relation_id, :fact_constituent_id

  validates :fact_constituent, presence: true
  validates :relation_id, uniqueness: { scope: [:fact_constituent_id, :role] }
  validates :role, inclusion: { in: ['subject', 'relative'] }
  validate :common_fact, on: :create

  private
  def common_fact
    if fact_constituent.nil? || relation.fact != fact_constituent.fact
      errors.add(:fact_constituent, I18n.t('relation_common_fact'))
    end
  end
end

