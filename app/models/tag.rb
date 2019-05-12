class Tag < ApplicationRecord
  validates :tagable_id, uniqueness: { scope: :tagable_type }
  after_validation :normalize_tagset

  # TODO: Check costs of `touch: true`
  belongs_to :tagable, polymorphic: true, touch: true

  private
  def normalize_tagset
    unless tagset.nil? || tagset.empty?
      tagset.map! { |t| t.parameterize(separator: '_') }
        .sort!.uniq!
    end
  end
end
