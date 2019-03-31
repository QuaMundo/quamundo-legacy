FactoryBot.define do
  factory :item do
    sequence(:id)   { |n| n }
    name            { "Item #{id}" }
    description     { "Description of item #{id}" }
    world           { build(:world, user: create(:user)) }
  end
end
