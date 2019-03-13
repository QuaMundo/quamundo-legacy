class World < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  with_options dependent: :destroy do |assoc|
    assoc.has_many :figures
  end

  default_scope { order(title: :asc) } 

  before_save :slugify

  def to_param
    slug
  end

  private
  # FIXME: Maybe Should go to ApplicationController
  def slugify
    self.slug = self.title.parameterize
  end
end
