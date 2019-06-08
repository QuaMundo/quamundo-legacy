module Traitable
  extend ActiveSupport::Concern

  included do
    has_one :trait, as: :traitable, dependent: :destroy

    after_create :set_attributeset

    private
    def set_attributeset
      self.create_trait
    end
  end
end
