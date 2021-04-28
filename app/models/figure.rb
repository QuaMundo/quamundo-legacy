# frozen_string_literal: true

class Figure < ApplicationRecord
  include WorldInventory
  include Factable
  include FigurePedigree

  has_many :figure_ancestors,
           class_name: 'FigureAncestor',
           dependent: :destroy,
           inverse_of: :figure
  # rubocop:disable Rails/InverseOf
  has_many :figure_descendants,
           class_name: 'FigureAncestor',
           foreign_key: :ancestor_id,
           dependent: :destroy
  # rubocop:enable Rails/InverseOf
  has_many :ancestors,
           through: :figure_ancestors
  has_many :descendants,
           through: :figure_descendants,
           source: :figure

  accepts_nested_attributes_for :figure_ancestors,
                                update_only: true,
                                allow_destroy: true,
                                reject_if: ->(attr) { attr[:ancestor_id].blank? }
end
