class Tag < ApplicationRecord
  validates :tagable_id, uniqueness: { scope: :tagable_type }
  after_validation :normalize_tagset

  # TODO: Check costs of `touch: true`
  belongs_to :tagable, polymorphic: true, touch: true, autosave: true

  private
  def normalize_tagset
    unless tagset.nil? || tagset.empty?
      tagset.sort!.uniq!
    end
  end
end
