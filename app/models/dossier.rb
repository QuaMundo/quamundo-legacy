class Dossier < ApplicationRecord
  include Benamed

  validates :content, :title, presence: true

  # TODO: Check costs of `touch: true`
  belongs_to :dossierable, polymorphic: true, touch: true

  has_many_attached :files

  alias_attribute :name, :title
end
