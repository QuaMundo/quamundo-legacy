# frozen_string_literal: true

FactoryBot.define do
  factory :concept do
    transient do
      user { build(:user) }
    end

    sequence(:name) { |n| "Concept #{n}" }
    description     { "Description of concept #{name}" }
    world           { build(:world, user: user) }

    factory :concept_with_notes, traits: [:with_notes]
    factory :concept_with_tags, traits: [:with_tags]
    factory :concept_with_traits, traits: [:with_traits]
    factory :concept_with_dossiers, traits: [:with_dossiers]
    factory :concept_with_facts, traits: [:with_facts]
    factory :concept_with_all,
            traits: %i[with_notes with_tags with_traits with_dossiers]
  end
end
