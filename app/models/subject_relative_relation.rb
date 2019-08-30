class SubjectRelativeRelation < ApplicationRecord
  belongs_to :relation
  belongs_to :subject,
    class_name: 'RelationConstituent',
    foreign_key: :subject_id
  belongs_to :relative,
    class_name: 'RelationConstituent',
    foreign_key: :relative_id

  has_one :fact_constituent, through: :relative

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
