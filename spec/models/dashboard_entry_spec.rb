RSpec.describe DashboardEntry, type: :model do
  include_context 'Session'

  it 'is a read-only model' do
    expect(DashboardEntry.new.readonly?).to be_truthy
  end

  context 'for user without a world', login: :user do
    it 'is empty' do
      expect(user.dashboard_entries).to be_empty
    end
  end

  context 'for user with worlds', login: :user_with_worlds do
    it 'lists last modified objects in descending order' do
      create_some_inventory(user_with_worlds)
      entries = user_with_worlds.dashboard_entries
      timestamps = entries.map(&:updated_at).sort.reverse
      expect(entries.count).to eq 15
      expect(entries.map(&:updated_at)).to eq(timestamps)
      expect(user_with_worlds.dashboard_entries.count).to be > 0
    end

    it 'lists only objects belonging to the current user' do
      expect(
        user_with_worlds.dashboard_entries.each.all? do |e|
          e.user == user_with_worlds
        end)
          .to be_truthy
    end

    it 'lists only objects belonging to the worlds of current user' do
      expect(
        user_with_worlds.dashboard_entries.each.all? do |e|
          user_with_worlds.worlds.include?(e.world)
        end)
          .to be_truthy
    end
  end
end
