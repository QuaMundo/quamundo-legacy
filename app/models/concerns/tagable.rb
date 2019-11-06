module Tagable
  extend ActiveSupport::Concern

  included do
    has_one :tag, as: :tagable, dependent: :destroy
    accepts_nested_attributes_for :tag, update_only: true

    after_validation :set_tagset

    private
    def set_tagset
      self.build_tag if self.tag.nil?
    end
  end
end
