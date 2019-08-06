RSpec.describe 'Listing locations', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_locations, user: user) }
  let(:other_world) { create(:world_with_locations) }

  context 'of an own world' do
    before(:example) { visit world_locations_path(world) }

    it 'shows cards of each location' do
      world.locations.each do |location|
        page
          .within("[id=\"location-#{location.id}\"]") do
          expect(page).to have_content(location.name)
          expect(page).to have_content(location.description)
          expect(page).to have_selector("img")
        end
      end
    end

    it 'shows index context menu' do
      page.first('.card-header') do
        expect(page).to have_link(href: world_path(world))
        expect(page).to have_link(href: new_world_location_path(world))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_locations_path(world) }
    end
  end

  context 'of another users world' do
    before(:example) { visit world_locations_path(other_world) }

    it 'does not show locations of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
