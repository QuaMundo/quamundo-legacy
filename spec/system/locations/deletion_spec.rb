RSpec.describe 'Deleting a location', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_locations, user: user) }
  let(:other_world) { create(:world_with_locations) }
  let(:location) { world.locations.first }
  let(:other_location) { other_world.locations.first }

  context 'of own world' do
    before(:example) { visit world_location_path(world, location) }

    it 'removes this location', :js, :comprehensive do
      page.accept_confirm() do
        page.first('nav.context-menu a.nav-link[title="delete"]').click
      end
      expect(page).to have_current_path(world_locations_path(world))
      expect(Location.find_by(id: location.id)).to be_falsey
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_location_path(world, location) }
    end
  end

  context 'of another users world' do
    before(:example) { visit world_location_path(other_world, other_location) }

    it 'refuses to remove location of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
