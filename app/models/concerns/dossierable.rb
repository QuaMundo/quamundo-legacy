# frozen_string_literal: true

module Dossierable
  extend ActiveSupport::Concern

  included do
    has_many :dossiers, as: :dossierable, dependent: :destroy
  end
end
