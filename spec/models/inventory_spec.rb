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
      5.times { create(:world_with_all, user: user) }
    end

    it 'contains all types of inventories' do
      available_types = %w(Item Figure Location Fact Concept)
      types = Inventory.pluck(:inventory_type).uniq
      expect(types).to include(*available_types)
    end

    it 'lists only objects belonging to the current user' do
      expect(user.inventories.each.all? { |e| e.user == user }).to be_truthy
    end

    it 'lists only objects belonging to the worlds of current user' do
      expect(
        user.inventories.each.all? do |e|
          user.worlds.include?(e.world)
        end)
          .to be_truthy
    end
  end
end
