# frozen_string_literal: true

class Relation < ApplicationRecord
  belongs_to :fact, touch: true, inverse_of: :relations
  has_many :relation_constituents, dependent: :destroy
  has_many :subject_relative_relations, dependent: :destroy
  has_many :subjects,
           -> { where(role: :subject) },
           class_name: 'RelationConstituent',
           inverse_of: :relation
  has_many :relatives,
           -> { where(role: :relative) },
           class_name: 'RelationConstituent',
           inverse_of: :relation

  accepts_nested_attributes_for :relation_constituents,
                                update_only: true,
                                allow_destroy: true,
                                reject_if: lambda { |attr|
                                  attr[:fact_constituent_id].blank? && attr[:id].blank?
                                }

  attr_readonly :fact_id

  validates :name, presence: true

  def unidirectional?
    reverse_name.nil?
  end

  def bidirectional?
    !unidirectional?
  end
end
