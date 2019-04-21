RSpec.describe Location, type: :model do
  include_context 'Session'
  include_context 'Users'

  let(:world) { user_with_worlds.worlds.first }
  let(:location) { build(:location, world: world) }
  # FIXME: Can srid be configured by default?
  let(:rgeo_factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

  it 'can only be created in context of a world' do
    expect(location).to be_valid
    expect(location.world).to eq(world)
  end

  it 'is invalid without a name' do
    a_location = world.locations.new
    expect(a_location).not_to be_valid
    expect { a_location.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(a_location.save).to be_falsey
  end

  it 'is indirectly linked to a user' do
    location.save
    expect(user_with_worlds.locations).to include(location)
    expect(location.user).to eq(user_with_worlds)
  end

  it 'can get an image attached' do
    attach_file(location.image, 'location.jpg')
    location.save!
    expect(location.image).to be_attached
  end

  it 'possibly has gps data' do
    location.lonlat = rgeo_factory.point(8.5, 49.5)
    location.save!
    location.reload
    expect(location.lonlat).to eq(rgeo_factory.point(8.5, 49.5))
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { location }
  end
end
