RSpec.describe Inventory, type: :model do
  include_context 'Session'

  let(:world) { create(:world, user: user) }

  it 'updates inventories on insert update and delete', db_triggers: true do
    count = 0
    [:location, :fact, :item, :concept, :figure].each do |obj|
      count += 1
      create(obj, world: world)
      expect(Inventory.count).to eq(count)
    end
    expect(Inventory.all.order(updated_at: :desc).limit(1).first
      .inventory_type).to eq('Figure')
    travel(1.day) do
      f = Item.last
      f.touch
      f.save
    expect(Inventory.all.order(updated_at: :desc).limit(1).first
      .inventory_type).to eq('Item')
    end
    [Location, Fact, Item, Concept, Figure].each do |obj|
      count -= 1
      obj.destroy_all
      expect(Inventory.count).to eq(count)
    end
  end
end
