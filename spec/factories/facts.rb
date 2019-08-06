FactoryBot.define do
  factory :fact do
    sequence(:name) { |n| "Fact No. #{n}" }
    description     { "Description of #{name}" }
    world           { build(:world, user: build(:user)) }

    trait :with_constituents do
      transient do
        fact_constituents_count       { 1 }
      end

      after(:build) do |fact, evaluator|
        [:item, :location, :figure].each do |inventory|
          create_list(:fact_constituent,
                      evaluator.fact_constituents_count,
                      fact: fact,
                      constituable: create(inventory, world: fact.world))
        end
      end
    end

    trait :with_start_date do
      if end_time
        start_time { random_date(0, end_time) }
      else
        start_time { random_date }
      end
    end

    trait :with_end_date do
      if start_time
        end_time { random_date(start_time, start_time + 100.years) }
      else
        end_time { random_date }
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

  def random_date(s = 0, e = DateTime.current + 100.years)
    Time.at(rand * (e - s).to_f + s.to_f)
  end
end

