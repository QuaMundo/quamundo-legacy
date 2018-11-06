require 'rails_helper'

RSpec.describe World, type: :model do
  include_context 'Users'
  include_context 'Worlds'

  it 'must not exist without an associated user' do
    world = build(:world, user: nil)
    expect { world.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(world.user).to be_falsey
    expect(world).not_to be_valid
  end

  it 'requires a title' do
    world = build(:world, title: nil)
    expect { world.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(world).not_to be_valid
  end

  it 'can get an image attached' do
    user = create(:user_with_worlds)
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

  it 'deletion also removes images and variants from storage' do
    paths = generate_some_image_paths(world)
    world.destroy
    expect(paths.none? { |p| File.exist? p } ).to be_truthy
  end

  # OPTIMIZE: This als is tested in feature spec `spec/features/world_spec.rb`
  # it 'removes old variants when image gets updated' do
  #   skip("Deletion of stale attachments seem not to happen in model!?")
  #   paths = generate_some_image_paths(world)
  #   attach_file(world.image, 'htrae.jpg')
  #   world.save!
  #   world.reload
  #   expect(paths.none? { |p| File.exist? p }).to be_truthy
  # end
end
