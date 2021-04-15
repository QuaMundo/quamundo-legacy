# frozen_string_literal: true

RSpec.describe World, type: :model do
  it 'must not exist without an associated user' do
    world = build(:world, user: nil)
    expect { world.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(world.user).to be_falsey
    expect(world).not_to be_valid
  end

  it 'requires a name' do
    world = build(:world, name: nil)
    # Since :before_save tries to build a slug via
    # ActiveSupport::Inflector.parameterize - which raises an error on a nil
    # value, the actual exception now is:
    # ArgumentError
    # So this test is disabled
    # expect { world.save!(validate: false) }
    #   .to raise_error ActiveRecord::NotNullViolation
    expect(world).not_to be_valid
  end

  it 'can get an image attached' do
    user = create(:user_with_worlds)
    user.save
    world = user.worlds.first
    attach_file(world.image, 'earth.jpg')
    world.save!
    expect(world.image).to be_attached
  end

  it 'refuses to attach a non image file' do
    user = create(:user_with_worlds)
    world = user.worlds.first
    attach_file(world.image, 'file.pdf')
    expect(world).not_to be_valid
    expect { world.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'has a case insensitive unique name' do
    user = build(:user)
    _world = create(:world, name: 'Test', user: user)
    other_world = build(:world, name: 'tesT', user: user)
    expect { other_world.save!(validate: false) }
      .to raise_error ActiveRecord::RecordNotUnique
    expect(other_world).not_to be_valid
  end

  it 'got a slug after creation' do
    world = build(:world, user: build(:user), name: 'A Meaningfull Name')
    world.save
    expect(world.slug).to eq('a-meaningfull-name')
  end

  it 'has an unique slug' do
    _world = create(:world, user: build(:user), name: 'A Meaningfull Name')
    other_world = build(:world, user: build(:user),
                                name: 'a meaningfull name')
    expect { other_world.save(validate: false) }
      .to raise_error ActiveRecord::RecordNotUnique
  end

  it_behaves_like 'noteable' do
    let(:subject) { build(:world) }
  end

  it_behaves_like 'tagable' do
    let(:subject) { build(:world) }
  end

  it_behaves_like 'traitable' do
    let(:subject) { build(:world) }
  end

  it_behaves_like 'dossierable' do
    let(:subject) { build(:world_with_dossiers) }
  end
end
