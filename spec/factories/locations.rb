FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    description     { "Description of location #{name}" }
    world           { build(:world, user: build(:user)) }
    lonlat          { "POINT(#{rand * 360.0 - 180.0} #{rand * 360.0 - 180.0})" }

    factory :location_with_notes, traits: [:with_notes]
    factory :location_with_tags, traits: [:with_tags]
    factory :location_with_traits, traits: [:with_traits]
    factory :location_with_dossiers, traits: [:with_dossiers]
    factory :location_with_facts, traits: [:with_facts]
    factory :location_with_all,
      traits: [:with_notes, :with_tags, :with_traits, :with_dossiers]
  end
end
