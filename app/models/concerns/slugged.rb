module Slugged
  extend ActiveSupport::Concern

  included do
    validates :title, :user, presence: true
    validates_uniqueness_of :title, case_sensitive: false

    before_save :slugify

    def to_param
      slug
    end
  end

  private
  def slugify
    self.slug = self.title.parameterize
  end
end
