# frozen_string_literal: true

module Slugged
  extend ActiveSupport::Concern

  included do
    validates :name, :user, presence: true
    validates :name, uniqueness: { case_sensitive: false }

    before_save :slugify

    def to_param
      slug
    end
  end

  private

  def slugify
    self.slug = name.parameterize
  end
end
