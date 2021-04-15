# frozen_string_literal: true

class Trait < ApplicationRecord
  validates :traitable_id, uniqueness: { scope: :traitable_type }

  # TODO: Check costs of `touch: true`
  belongs_to :traitable, polymorphic: true, touch: true, autosave: true
end
