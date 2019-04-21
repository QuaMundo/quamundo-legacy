RSpec.describe 'Deleting a location', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.last }
  let(:other_world) { other_user_with_worlds.worlds.last }
  let(:location) { world.locations.first }
  let(:other_location) { other_world.locations.first }

  context 'of own world' do
    before(:example) { visit world_location_path(world, location) }

    it 'removes this location', :js, :comprehensive do
      page.accept_confirm() do
        page.first('nav.context-menu a.nav-link[title="delete"]').click
      end
      expect(current_path).to eq(world_locations_path(world))
      expect(Location.find_by(id: location.id)).to be_falsey
    end
  end

  context 'of another users world' do
    before(:example) { visit world_location_path(other_world, other_location) }

    it 'refuses to remove location of another users world' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
