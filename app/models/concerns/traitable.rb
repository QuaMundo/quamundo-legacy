# frozen_string_literal: true

module Traitable
  extend ActiveSupport::Concern

  included do
    has_one :trait, as: :traitable, dependent: :destroy
    accepts_nested_attributes_for :trait, update_only: true

    after_validation :set_attributeset

    private

    def set_attributeset
      build_trait if trait.nil?
    end
  end
end
