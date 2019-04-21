RSpec.describe 'Listing locations', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }
  let(:other_world) { other_user_with_worlds.worlds.first }

  context 'of an own world' do
    before(:example) { visit world_locations_path(world) }

    it 'shows cards of each location' do
      world.locations.each do |location|
        page
          .within("div[id=\"card-location-#{location.id}\"]") do
          expect(page).to have_content(location.name)
          expect(page).to have_content(location.description)
          expect(page).to have_content(location.lonlat.lon)
          expect(page).to have_content(location.lonlat.lat)
          expect(page).to have_selector(".card-img")
        end
      end
    end

    it 'shows index context menu' do
      page.first('.card-header') do
        expect(page).to have_link(href: world_path(world))
        expect(page).to have_link(href: new_world_location_path(world))
      end
    end
  end

  context 'of another users world' do
    before(:example) { visit world_locations_path(other_world) }

    it 'does not show locations of another users world' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
