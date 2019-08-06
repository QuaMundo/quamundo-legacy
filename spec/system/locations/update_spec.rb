RSpec.describe 'Updating/Editing a location', type: :system do

  include_context 'Session'

  let(:world) { create(:world_with_locations, user: user) }
  let(:other_world) { create(:world_with_locations) }
  let(:location) { world.locations.first }
  let(:other_location) { other_world.locations.first }

  context 'of own world' do
    before(:example) { visit edit_world_location_path(world, location) }

    # FIXME: Following 2 examples are duplicate in
    # `spec/system/location/create_spec.rb` and
    # `spec/system/location/update_spec.rb`
    it 'has no button to get current position without javascript' do
      expect(page).to have_selector('#get_device_pos.d-none')
    end

    it 'has button to get current position via javascript', :js, :comprehensive do
      page.execute_script('navigator.geolocation.getCurrentPosition = function(success) { success({coords: {latitude: 12, longitude: 34}}); }')
      page.find('#get_device_pos').click
      expect(page.find('#location_lonlat').value).to eq '12, 34'
    end

    it 'prefills position field with "lat.x, lon.y"' do
      location.lonlat = 'POINT(8.5 49.5)'
      location.save
      visit edit_world_location_path(world, location)
      expect(page)
        .to have_selector('input#location_lonlat[value="49.5, 8.5"]')
    end

    it 'can update name, position and description' do
      # FIXME: Duplicate action below
      QuamundoTestHelpers::attach_file(
        location.image, fixture_file_name('location.jpg'))
      visit edit_world_location_path(world, location)
      expect(page).to have_selector("img##{element_id(location, 'img')}")
      fill_in('Name', with: 'A new location')
      fill_in('Description', with: 'New description')
      fill_in('Latitude/Longitude', with: '55.123, 19.321')
      click_button('submit')
      location.reload
      expect(page).to have_current_path(world_location_path(world, location))
      expect(page).to have_content('A new location')
      expect(page).to have_content('New description')
      expect(page).to have_content('55.123, 19.321')
      expect(location.lonlat)
        .to eq(RGeo::Geographic.spherical_factory(srid: 4326).point(19.321, 55.123))
    end

    it 'attaches an image', :comprehensive do
      page.attach_file('location_image', fixture_file_name('location.jpg'))
      click_button('submit')
      expect(page).to have_current_path(world_location_path(world, location))
      expect(location.image).to be_attached
      expect(page).to have_selector('img.location-image')
    end

    it 'refuses to attach non image files', :comprehensive do
      page.attach_file('location_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to have_current_path(world_location_path(world, location))
      expect(location.image).not_to be_attached
      pending("Show view not yet implemented")
      expect(page).to have_selector('.alert', text: 'Only images may be')
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_location_path(world, location) }
    end
  end

  context 'of another users world' do
    before(:example) { visit edit_world_location_path(other_world, other_location) }

    it 'refuses to update another users worlds locations' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
