# frozen_string_literal: true

FactoryBot.define do
  factory :relation_constituent do
    transient do
      user              { build(:user) }
      fact              { build(:fact, user: user) }
    end

    relation          { create(:relation, fact: fact) }
    fact_constituent  { build(:fact_constituent, fact: relation.fact) }
    role              { :subject }
  end
end
