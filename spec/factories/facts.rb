FactoryBot.define do
  factory :fact do
    transient do
      user              { build(:user) }
    end

    sequence(:name) { |n| "Fact No. #{n}" }
    description     { "Description of #{name}" }
    world           { build(:world, user: user) }

    trait :with_constituents do
      transient do
        fact_constituents_count       { 1 }
      end

      after(:build) do |fact, evaluator|
        [:item, :location, :figure, :concept].each do |inventory|
          evaluator.fact_constituents_count.times do
            create(:fact_constituent,
                  inventory_type: inventory, fact: fact)
          end
        end
      end
    end

    factory :fact_with_notes, traits: [:with_notes]
    factory :fact_with_tags, traits: [:with_tags]
    factory :fact_with_traits, traits: [:with_traits]
    factory :fact_with_dossiers, traits: [:with_dossiers]
    factory :fact_with_constituents, traits: [:with_constituents]
    factory :fact_with_all,
      traits: [:with_notes, :with_tags, :with_traits,
               :with_dossiers, :with_constituents]
  end
end

