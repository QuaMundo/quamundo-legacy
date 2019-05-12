FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    description     { "Description of location #{name}" }
    world           { build(:world, user: build(:user)) }
    lonlat          { "POINT(#{rand * 360.0 - 180.0} #{rand * 360.0 - 180.0})" }

    transient do
      notes_count       { 3 }
    end

    after(:create) do |location, evaluator|
      create_list(:note, evaluator.notes_count, noteable: location)
      location.create_tag(tagset: ['location_tag'])
    end
  end
end
