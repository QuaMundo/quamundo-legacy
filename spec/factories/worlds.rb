FactoryBot.define do
  factory :world do
    sequence(:title)  { |n| "World #{n}" }
    description       { "Description of world '#{title}'" }
    user              { build(:user) }
    image             { fixture_file_upload(fixture_file_name('earth.jpg')) }

    trait :with_figures do
      transient do
        figures_count       { 1 }
      end

      after(:build) do |world, evaluator|
        create_list(:figure, evaluator.figures_count, world: world)
      end
    end

    trait :with_items do
      transient do
        items_count         { 1 }
      end

      after(:build) do |world, evaluator|
        create_list(:item, evaluator.items_count, world: world)
      end
    end

    trait :with_locations do
      transient do
        locations_count     { 1 }
      end

      after(:build) do |world, evaluator|
        create_list(:location, evaluator.locations_count, world: world)
      end
    end

    trait :with_facts do
      transient do
        facts_count         { 1 }
      end

      after(:build) do |world, evaluator|
        create_list(:fact_with_constituents,
                    evaluator.facts_count, world: world)
      end
    end

    factory :world_with_notes, traits: [:with_notes]
    factory :world_with_tags, traits: [:with_tags]
    factory :world_with_traits, traits: [:with_traits]
    factory :world_with_dossiers, traits: [:with_dossiers]
    factory :world_with_figures, traits: [:with_figures]
    factory :world_with_items, traits: [:with_items]
    factory :world_with_locations, traits: [:with_locations]
    factory :world_with_facts, traits: [:with_facts]

    factory :world_with_all, traits: [
      :with_notes,
      :with_tags,
      :with_traits,
      :with_dossiers,
      :with_figures,
      :with_items,
      :with_locations,
      :with_facts
    ]
  end
end
