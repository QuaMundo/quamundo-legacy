class Note < ApplicationRecord
  validates :content, presence: true

  # TODO: Check costs of `touch: true`
  belongs_to :noteable, polymorphic: true, touch: true
end
