RSpec.describe Location, type: :model do
  include_context 'Session'

  let(:location) { build(:location, world: world) }
  # FIXME: Can srid be configured by default?
  let(:rgeo_factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

  it 'is invalid without a name' do
    a_location = world.locations.new
    expect(a_location).not_to be_valid
    expect { a_location.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(a_location.save).to be_falsey
  end

  it 'possibly has gps data' do
    location.lonlat = rgeo_factory.point(8.5, 49.5)
    location.save!
    location.reload
    expect(location.lonlat).to eq(rgeo_factory.point(8.5, 49.5))
  end

  it_behaves_like 'noteable' do
    let(:subject) { location }
  end

  it_behaves_like 'inventory' do
    let(:subject) { location }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { location }
  end

  it_behaves_like 'tagable' do
    let(:subject) { location }
  end

  it_behaves_like 'updates parents' do
    let(:subject) { location }
    let(:parent)  { location.world }
  end
end
