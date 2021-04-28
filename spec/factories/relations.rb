# frozen_string_literal: true

module QuamundoRelationConstituentHelper
  class << self
    def random_relation_constituent(relation, role)
      relation
        .relation_constituents
        .create(fact_constituent: random_fact_constituent(relation.fact),
                role: role)
    end

    private

    def types
      %i[concept figure item location]
    end

    def random_type
      types[rand(types.count)]
    end

    def random_inventory(world)
      FactoryBot.create(random_type, world: world)
    end

    def random_fact_constituent(fact)
      fact
        .fact_constituents
        .create(constituable: random_inventory(fact.world))
    end
  end
end

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
        relation.save
        evaluator.subjects_count.times do
          QuamundoRelationConstituentHelper
            .random_relation_constituent(relation, :subject)
        end
        evaluator.relatives_count.times do
          QuamundoRelationConstituentHelper
            .random_relation_constituent(relation, :relative)
        end
      end
    end

    factory :relation_with_constituents, traits: [:with_constituents]
  end
end
