module Slugged
  extend ActiveSupport::Concern

  included do
    validates :name, :user, presence: true
    validates_uniqueness_of :name, case_sensitive: false

    before_save :slugify

    def to_param
      slug
    end
  end

  private
  def slugify
    self.slug = self.name.parameterize
  end
end
