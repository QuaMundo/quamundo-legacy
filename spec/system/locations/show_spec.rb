RSpec.describe 'Showing a location', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }
  let(:location) { world.locations.first }

  context 'of own world' do
    before(:example) { visit world_location_path(world, location) }

    it 'shows location details' do
      expect(page).to have_content(location.name)
      expect(page).to have_content(location.description)
      expect(page)
        .to have_link(location.world.title, href: world_path(world))
      expect(page).to have_content(location.lonlat.lon)
      expect(page).to have_content(location.lonlat.lat)
    end

    it 'shows location menu', :comprehensive do
      page.first('nav.nav') do
        expect(page).to have_link(href: new_world_location_path(world))
        expect(page).to have_link(href: world_locations_path(world))
        expect(page).to have_link(href: edit_world_location_path(world, location))
        expect(page).to have_link('delete',
                                  href: world_location_path(world, location))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_location_path(world, location) }
    end
  end

  context 'with image' do
    before(:example) do
      location.image = fixture_file_upload(fixture_file_name('location.jpg'))
      visit(world_location_path(world, location))
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.figure-image')
    end
  end

  context 'of another users world' do
    let(:other_world) { other_user_with_worlds.worlds.first }
    let(:other_location) { other_world.locations.first }

    before(:example) { visit world_location_path(other_world, other_location) }

    it 'redirects to worlds index' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
