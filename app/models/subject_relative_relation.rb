class SubjectRelativeRelation < ApplicationRecord
  belongs_to :relation, inverse_of: :subject_relative_relations
  belongs_to :subject,
    class_name: 'RelationConstituent',
    foreign_key: :subject_id
  belongs_to :relative,
    class_name: 'RelationConstituent',
    foreign_key: :relative_id

  has_one :fact_constituent, through: :relative

  validates :subject_id, uniqueness: { scope: :relative_id }

  # this is a read-only model!
  def readonly?
    true
  end

  # in case one wants to refresh the materialized view
  def self.refresh
    connection
      .execute('REFRESH MATERIALIZED VIEW subject_relative_relations;')
  end
end
