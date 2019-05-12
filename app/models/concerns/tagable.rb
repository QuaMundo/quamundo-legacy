module Tagable
  extend ActiveSupport::Concern

  included do
    has_one :tag, as: :tagable, dependent: :destroy

    after_create :set_tagset

    private
    def set_tagset
      self.create_tag
    end
  end
end
