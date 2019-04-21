FactoryBot.define do
  factory :location do
    sequence(:id)   { |n| n }
    name            { "Location #{id}" }
    description     { "Description of location #{id}" }
    world           { build(:world, user: create(:user)) }
    lonlat          { "POINT(#{rand * 360.0 - 180.0} #{rand * 360.0 - 180.0})" }
  end
end
