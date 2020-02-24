class FigureAncestor < ApplicationRecord
  belongs_to :figure
  belongs_to :ancestor,
    class_name: 'Figure',
    foreign_key: :ancestor_id

  validate :unique_ancestors
  validate :no_self_references

  private
  def no_self_references
    unless figure_id != ancestor_id
      errors.add(:ancestor_id, I18n.t('figure_ancestors.no_self_references'))
    end
  end

  def unique_ancestors
    unless FigureAncestor
      .where(figure_id: figure_id, ancestor_id: ancestor_id)
      .pluck(:figure_id, :ancestor_id).empty?
      errors.add(:ancestor_id, I18n.t('figure_ancestors.no_doubles'))
    end
  end
end
