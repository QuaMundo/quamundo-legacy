# frozen_string_literal: true

RSpec.shared_examples 'updates parents', type: :model do
  include ActiveSupport::Testing::TimeHelpers

  it 'updates parent object after modification', :comprehensive do
    updated_at = parent.updated_at
    travel(rand * 5.days + 1.hour) do
      # rubocop:disable Rails/SkipsModelValidations
      subject.touch
      # rubocop:enable Rails/SkipsModelValidations
      subject.save
      expect(parent.updated_at).to be > (updated_at + 1.hour)
    end
  end
end
