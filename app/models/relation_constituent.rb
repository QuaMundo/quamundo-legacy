# frozen_string_literal: true

class RelationConstituent < ApplicationRecord
  belongs_to :fact_constituent, inverse_of: :relation_constituents
  belongs_to :relation, inverse_of: :relation_constituents

  has_one :fact, through: :relation

  # rubocop:disable Rails/HasManyOrHasOneDependent
  # rubocop:disable Rails/InverseOf
  has_many :relatives,
           foreign_key: :subject_id,
           class_name: 'SubjectRelativeRelation'
  # rubocop:enable Rails/HasManyOrHasOneDependent
  # rubocop:enable Rails/InverseOf

  attr_readonly :relation_id, :fact_constituent_id

  validates :fact_constituent, presence: true
  validates :relation_id, uniqueness: { scope: %i[fact_constituent_id role] }
  validates :role, inclusion: { in: %w[subject relative] }
  validate :common_fact, on: :create

  private

  def common_fact
    return unless fact_constituent.nil? || relation.fact != fact_constituent.fact

    # FIXME: Add i18n
    errors.add(:fact_constituent, I18n.t('relation_common_fact'))
  end
end
