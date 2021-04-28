# frozen_string_literal: true

module Tagable
  extend ActiveSupport::Concern

  included do
    has_one :tag, as: :tagable, dependent: :destroy
    accepts_nested_attributes_for :tag, update_only: true

    after_validation :set_tagset

    private

    def set_tagset
      build_tag if tag.nil?
    end
  end
end
