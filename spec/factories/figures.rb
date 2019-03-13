FactoryBot.define do
  factory :figure do
    sequence(:id)   { |n| n }
    first_name      { "First Name #{id}" }
    last_name       { "Last Name #{id}" }
    nick            { "figure_#{id}" }
    description     { "Description of figure #{nick}" }
    world           { build(:world, user: create(:user)) }
  end
end
