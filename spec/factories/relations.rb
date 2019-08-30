FactoryBot.define do
  factory :relation do
    transient do
      bidirectional   { false }
      user            { build(:user) }
    end

    name            { 'relates to' }
    reverse_name    { bidirectional ? 'is related to by' : nil }
    description     { "Description of relation '#{name}'" }
    fact            { build(:fact, user: user) }

    trait :with_constituents do
      transient do
        subjects_count    { 2 }
        relatives_count   { 2 }
      end

      after(:build) do |relation, evaluator|
        relation.fact.save
        relation.save
        evaluator.subjects_count.times do
          # FIXME: Refactor, not DRY!
          i_type = [:concept, :figure, :item, :location][rand(4)]
          i = create(i_type, world: relation.fact.world)
          fc = relation.fact.fact_constituents.create(constituable: i)
          relation.relation_constituents.create(
            fact_constituent: fc, role: :subject)
        end
        evaluator.relatives_count.times do
          # FIXME: Refactor, not DRY!
          i_type = [:concept, :figure, :item, :location][rand(4)]
          i = create(i_type, world: relation.fact.world)
          fc = relation.fact.fact_constituents.create(constituable: i)
          relation.relation_constituents.create(
            fact_constituent: fc, role: :relative)
        end
      end
    end

    factory :relation_with_constituents, traits: [:with_constituents]
  end
end
