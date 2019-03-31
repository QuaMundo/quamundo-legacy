FactoryBot.define do
  factory :world do
    sequence(:title)  { |n| "World #{n}" }
    description       { "Description of world '#{title}'" }
    user              { build(:user) }
    image             { fixture_file_upload(fixture_file_name('earth.jpg')) }

    transient do
      figures_count       { 3 }
      items_count         { 3 }
    end

    after(:create) do |world, evaluator|
      create_list(:figure, evaluator.figures_count, world: world)
      create_list(:item, evaluator.items_count, world: world)
    end
  end
end
