# frozen_string_literal: true

RSpec.describe 'LonLat Helper', type: :helper do
  let(:pos) { RGeo::Geographic.spherical_factory(srid: 4326).point(8.5, 49.5) }

  it 'extracts string from geocoordinates' do
    expect(helper.get_lonlat(pos)).to eq('49.5, 8.5')
  end

  it 'returns empty string on empty position data' do
    expect(helper.get_lonlat(nil)).to eq('')
  end
end
