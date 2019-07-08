FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    description     { "Description of #{name}" }
    world           { build(:world, user: build(:user)) }

    factory :item_with_notes, traits: [:with_notes]
    factory :item_with_tags, traits: [:with_tags]
    factory :item_with_traits, traits: [:with_traits]
    factory :item_with_dossiers, traits: [:with_dossiers]
    factory :item_with_facts, traits: [:with_facts]
    factory :item_with_all,
      traits: [:with_notes, :with_tags, :with_traits, :with_dossiers]
  end
end
