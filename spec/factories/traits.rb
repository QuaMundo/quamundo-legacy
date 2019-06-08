FactoryBot.define do
  factory :trait do
    attributeset {
      {
        'key_1'   => 'value 1',
        'key_2'   => 'value 2',
        'key_3'   => 'value 3'
      }
    }
    association :traitable
  end
end
