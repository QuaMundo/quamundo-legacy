# frozen_string_literal: true

FactoryBot.define do
  factory :trait do
    attributeset do
      {
        'key_1' => 'value 1',
        'key_2' => 'value 2',
        'key_3' => 'value 3'
      }
    end
    association :traitable
  end
end
