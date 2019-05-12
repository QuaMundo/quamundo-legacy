FactoryBot.define do
  factory :figure do
    sequence(:name) { |n| "figure_#{n}" }
    description     { "Description of figure #{name}" }
    world           { build(:world, user: build(:user)) }

    transient do
      notes_count       { 3 }
    end

    after(:create) do |figure, evaluator|
      create_list(:note, evaluator.notes_count, noteable: figure)
      figure.create_tag(tagset: ['figure_tag'])
    end
  end
end
