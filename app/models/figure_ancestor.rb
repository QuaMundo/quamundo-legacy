# frozen_string_literal: true

class FigureAncestor < ApplicationRecord
  belongs_to :figure, inverse_of: :figure_ancestors, touch: true
  belongs_to :ancestor,
             class_name: 'Figure',
             inverse_of: :figure_ancestors,
             touch: true

  validate :unique_ancestors
  validate :no_self_references
  validate :common_world, on: %i[create update]

  private

  def no_self_references
    errors.add(:ancestor_id, I18n.t('figure_ancestors.no_self_references')) unless figure_id != ancestor_id
  end

  def unique_ancestors
    unless FigureAncestor
           .where(figure_id: figure_id, ancestor_id: ancestor_id)
           .pluck(:figure_id, :ancestor_id).empty?
      errors.add(:ancestor_id, I18n.t('figure_ancestors.no_doubles'))
    end
  end

  def common_world
    errors.add(:ancestor_id, I18n.t('ancestor_common_world')) unless figure.world == ancestor.world
  end
end
