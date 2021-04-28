# frozen_string_literal: true

FactoryBot.define do
  factory :fact_constituent do
    transient do
      inventory_type    { random_inventory_type }
      user              { build(:user) }
      world             { build(:world, user: user) }
    end

    fact              { build(:fact, world: world) }
    constituable      { build(inventory_type, world: fact.world) }
  end
end
