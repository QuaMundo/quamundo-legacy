# frozen_string_literal: true

RSpec.describe 'Showing a location', type: :system do
  include_context 'Session'

  let(:location)    { create(:location, user: user) }
  let(:world)       { location.world }
  let(:other_world) { create(:world_with_locations) }

  context 'of own world' do
    before(:example) { visit world_location_path(world, location) }

    it 'shows location details' do
      expect(page).to have_content(location.name)
      expect(page).to have_content(location.description)
      expect(page)
        .to have_link(location.world.name, href: world_path(world))
      expect(page).to have_content(location.lonlat.lon)
      expect(page).to have_content(location.lonlat.lat)
    end

    it 'shows location menu', :comprehensive do
      page.first('.nav') do
        expect(page).to have_link(href: new_world_location_path(world))
        expect(page).to have_link(href: world_locations_path(world))
        expect(page).to have_link(href: edit_world_location_path(world, location))
        expect(page).to have_link('delete',
                                  href: world_location_path(world, location))
      end
    end

    it 'shows location map', js: true do
      expect(page).to have_selector('#map')
      expect(page).to have_selector('#popup', visible: false)
      map = page.find('canvas')
      x = map.rect.width / 2
      y = map.rect.height / 2
      map.click(x: x, y: y)
      # FIXME: After click in canvas a tooltip should be rendered with
      # location name as header - find out how to test this!?
      pending 'Find out how to test canvas click'
      expect(page).to have_selector('h3.popover-header', text: location.name)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_location_path(world, location) }
    end

    it_behaves_like 'associated note' do
      let(:subject) { create(:location_with_notes, world: world) }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { location }
    end

    it_behaves_like 'associated traits' do
      let(:subject) { create(:location_with_traits, world: world) }
    end

    it_behaves_like 'associated dossiers' do
      let(:subject) { create(:location_with_dossiers, user: user) }
    end

    it_behaves_like 'associated facts' do
      let(:subject) { create(:location_with_facts, facts_count: 3, world: world) }
      let(:path)    { world_location_path(subject.world, subject) }
    end

    it_behaves_like 'associated relations' do
      let(:subject) { create(:location, world: world) }
    end

    it_behaves_like 'inventory timelines' do
      let(:subject)   { location }
    end
  end

  context 'with image' do
    before(:example) do
      location.image = fixture_file_upload(fixture_file_name('location.jpg'))
      location.save
      visit(world_location_path(world, location))
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.location-image')
    end
  end

  context 'of another users world' do
    let(:other_location) { other_world.locations.first }

    before(:example) { visit world_location_path(other_world, other_location) }

    it 'redirects to worlds index' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
