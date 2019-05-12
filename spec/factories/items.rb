FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    description     { "Description of #{name}" }
    world           { build(:world, user: build(:user)) }

    transient do
      notes_count       { 3 }
    end

    after(:create) do |item, evaluator|
      create_list(:note, evaluator.notes_count, noteable: item)
      item.create_tag(tagset: ['item_tag'])
    end
  end
end
