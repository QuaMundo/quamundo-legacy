RSpec.describe 'Updating/Editing a location', type: :system do

  include_context 'Session'

  let(:location)        { create(:location, user: user) }
  let(:world)           { location.world }
  let(:other_location)  { create(:location) }
  let(:other_world)     { other_location.world }

  context 'of own world' do
    it 'has button to get current position via javascript', :js, :comprehensive do
      visit edit_world_location_path(world, location)
      page.execute_script(
        'navigator.geolocation.getCurrentPosition = function(success) { success({coords: {latitude: 12, longitude: 34}}); }'
      )
      page.find('#get_device_pos').click
      expect(page.find('#location_lonlat').value).to eq '12, 34'
    end

    it 'prefills position field with "lat.x, lon.y"' do
      visit edit_world_location_path(world, location)
      location.lonlat = 'POINT(8.5 49.5)'
      location.save
      visit edit_world_location_path(world, location)
      expect(page)
        .to have_selector('input#location_lonlat[value="49.5, 8.5"]')
    end

    it 'can update name, position and description' do
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
      visit edit_world_location_path(world, location)
      page.attach_file('location_image', fixture_file_name('location.jpg'))
      click_button('submit')
      expect(page).to have_current_path(world_location_path(world, location))
      expect(location.reload.image).to be_attached
      expect(page).to have_selector('img.location-image')
    end

    it 'refuses to attach non image files', :comprehensive do
      visit edit_world_location_path(world, location)
      page.attach_file('location_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to have_current_path(world_location_path(world, location))
      expect(location.image).not_to be_attached
      expect(page).to have_selector('.alert', text: /^Failed to update/)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_location_path(world, location) }
    end

    it_behaves_like 'editable tags' do
      let(:path)    { edit_world_location_path(world, location) }
    end

    it_behaves_like 'editable traits' do
      let(:subject)     { create(:location, :with_traits, user: user) }
    end
  end

  context 'of another users world' do
    it 'refuses to update another users worlds locations' do
      visit edit_world_location_path(other_world, other_location)
      expect(page).to have_current_path(worlds_path)
    end
  end
end
