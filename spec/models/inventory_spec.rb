RSpec.describe Inventory, type: :model do
  include_context 'Session'

  it 'is a read-only model' do
    expect(Inventory.new.readonly?).to be_truthy
  end

  context 'for user without a world' do
    let(:user) { build(:user) }

    it 'is empty' do
      expect(user.inventories).to be_empty
    end
  end

  context 'for user with worlds' do
    before(:example) do
      create(:world_with_all, user: user)
    end

    it 'contains all types of inventories' do
      refresh_materialized_views(Inventory)
      available_types = %w(Item Figure Location Fact Concept)
      types = Inventory.pluck(:inventory_type).uniq
      expect(types).to include(*available_types)
    end

    it 'lists only objects belonging to the current user' do
      expect(user.inventories.each.all? { |e| e.user == user }).to be_truthy
    end

    it 'lists only objects belonging to the worlds of current user' do
      users_worlds = user.worlds
      expect(user.inventories.all? { |i| users_worlds.include?(i.world) })
          .to be_truthy
    end
  end
end
