# frozen_string_literal: true

RSpec.describe Location, type: :model do
  include_context 'Session'

  let(:world) { build(:world) }
  let(:rgeo_factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

  it 'is invalid without a name' do
    a_location = build(:location, world: world, name: nil)
    expect(a_location).not_to be_valid
    expect { a_location.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(a_location.save).to be_falsey
  end

  it 'possibly has gps data' do
    location = build(:location, world: world)
    location.lonlat = rgeo_factory.point(8.5, 49.5)
    location.save!
    location.reload
    expect(location.lonlat).to eq(rgeo_factory.point(8.5, 49.5))
  end

  it_behaves_like 'noteable' do
    let(:subject) { build(:location_with_notes) }
  end

  it_behaves_like 'inventory' do
    let(:subject) { build(:location, world: world) }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { build(:location, world: world) }
  end

  it_behaves_like 'traitable' do
    let(:subject) { build(:location) }
  end

  it_behaves_like 'dossierable' do
    let(:subject) { build(:location_with_dossiers) }
  end

  it_behaves_like 'tagable' do
    let(:subject) { build(:location) }
  end

  it_behaves_like 'updates parents' do
    let(:parent)  { create(:world) }
    let(:subject) { create(:location, world: parent) }
  end

  it_behaves_like 'relatable' do
    let(:subject) { build(:location, world: world) }
  end
end
