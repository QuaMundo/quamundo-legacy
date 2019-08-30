class Relation < ApplicationRecord
  belongs_to :fact, touch: true
  has_many :relation_constituents, dependent: :destroy
  has_many :subject_relative_relations
  has_many :subjects,
    -> { where(role: :subject) },
    class_name: 'RelationConstituent'
  has_many :relatives,
    -> { where(role: :relative) },
    class_name: 'RelationConstituent'

  attr_readonly :fact_id

  validates :name, presence: true

  def unidirectional?
    reverse_name.nil?
  end

  def bidirectional?
    !unidirectional?
  end
end

