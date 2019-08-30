FactoryBot.define do
  factory :figure do
    transient do
      user            { build(:user) }
    end

    sequence(:name) { |n| "figure_#{n}" }
    description     { "Description of figure #{name}" }
    world           { build(:world, user: user) }

    factory :figure_with_notes, traits: [:with_notes]
    factory :figure_with_tags, traits: [:with_tags]
    factory :figure_with_traits, traits: [:with_traits]
    factory :figure_with_dossiers, traits: [:with_dossiers]
    factory :figure_with_facts, traits: [:with_facts]
    factory :figure_with_all,
      traits: [:with_notes, :with_tags, :with_traits, :with_dossiers]
  end
end
