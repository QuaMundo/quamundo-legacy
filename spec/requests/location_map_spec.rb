# frozen_string_literal: true

RSpec.describe 'Location map', type: :request do
  include_context 'Session'

  let(:world)       { create(:world, user: user) }

  context 'location without coordinates' do
    let(:location) { create(:location, world: world, lonlat: nil) }

    it 'does not render a map view' do
      get(world_location_path(world, location))
      expect(response).not_to render_template(partial: 'locations/_location_map')
    end
  end

  context 'location with coordinates' do
    let(:location) do
      create(:location, world: world,
                        lonlat: 'POINT(49.9 8.9)')
    end
    it 'renders map view' do
      get(world_location_path(world, location))
      expect(response).to render_template(partial: 'locations/_location_map')
    end
  end
end
