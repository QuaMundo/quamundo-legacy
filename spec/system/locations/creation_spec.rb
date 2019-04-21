RSpec.describe 'Creating a location', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }

  context 'in own world' do
    before(:example) { visit new_world_location_path(world) }

    it 'is successful with completed form' do
      location_count = world.locations.count
      fill_in('Name', with: 'A new location')
      fill_in('Description', with: 'A new locations description')
      page.attach_file('location_image', fixture_file_name('location.jpg'))
      click_button('submit')
      expect(world.locations.count).to be > location_count
      expect(page).to have_selector('.alert-info',
                                    text: 'A new location successfully')
      expect(current_path) .to eq(
        world_location_path(world, Location.find_by(name: 'A new location'))
      )
    end

    it 'saves a locations position' do
      fill_in('Name', with: 'Location with position')
      fill_in('Latitude/Longitude', with: '49.5, 8.5')
      click_button('submit')
      new_location = Location.find_by(name: 'Location with position')
      expect(current_path).to eq(world_location_path(world, new_location))
      expect(new_location.lonlat)
        .to eq(RGeo::Geographic.spherical_factory(srid: 4326).point(8.5, 49.5))
    end

    it 'redirects to new form if name is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: 'Name')
    end

    it_behaves_like 'valid_view' do
      let(:subject) { new_world_location_path(world) }
    end
  end

  context 'in other users world'
end
