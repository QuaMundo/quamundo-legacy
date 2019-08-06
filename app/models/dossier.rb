class Dossier < ApplicationRecord
  include Benamed

  validates :name, presence: true

  # TODO: Check costs of `touch: true`
  belongs_to :dossierable, polymorphic: true, touch: true

  has_many_attached :files

  def images
    files.select(&:image?)
  end

  def audios
    files.select(&:audio?)
  end

  def videos
    files.select(&:video?)
  end

  def other_files
    files.reject { |f| f.image? || f.audio? || f.video? }
  end
end
