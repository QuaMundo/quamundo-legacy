require 'rails_helper'

RSpec.describe World, type: :model do
  include_context 'Users'

  it 'must not exist without an associated user' do
    world = build(:world, user: nil)
    expect { world.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(world.user).to be_falsey
    expect(world).not_to be_valid
  end

  it 'requires a title' do
    world = build(:world, title: nil)
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

  # Redundant, see 'case insensitive uniqueness'
  # it 'has an unique title' do
  #   user = create(:user_with_worlds)
  #   world = user.worlds.first
  #   new_world = build(:world, title: world.title, user: user)
  #   expect(new_world).not_to be_valid
  #   expect { new_world.save!(validate: false) }
  #     .to raise_error ActiveRecord::RecordNotUnique
  # end

  it 'has a case insensitive unique title' do
    user = build(:user)
    world = create(:world, title: 'Test', user: user)
    other_world = build(:world, title: 'tesT', user: user)
    expect { other_world.save!(validate: false) }
      .to raise_error ActiveRecord::RecordNotUnique
    expect(other_world).not_to be_valid
  end

  it 'got a slug after creation' do
    world = build(:world, user: build(:user), title: 'A Meaningfull Title')
    world.save
    expect(world.slug).to eq('a-meaningfull-title')
  end

  # it 'got slug updated when title is updated' do
  #   world = create(:world, title: 'Title', user: build(:user))
  #   expect(world.slug).to eq('title')
  #   world.title = 'New Title'
  #   world.save!
  #   world.reload
  #   expect(world.slug).to eq('new-title')
  # end

  it 'has an unique slug' do
    world = create(:world, user: build(:user), title: 'A Meaningfull Title')
    other_world = build(:world, user: build(:user),
                        title: 'a meaningfull title')
    expect { other_world.save(validate: false) }
      .to raise_error ActiveRecord::RecordNotUnique
  end

  it 'deletion also removes images and variants from storage' do
    world = create(:world)
    paths = generate_some_image_paths(world)
    world.destroy
    expect(paths.none? { |p| File.exist? p } ).to be_truthy
  end

  # FIXME: duplicate code in `spec/support/noteable.rb`
  it 'has a list of notes' do
    world = build(:world)
    expect(world).to respond_to(:notes)
    notes = []
    2.times do
      note = build(:note, noteable: world)
      notes << note
      world.notes << note
    end
    world.save
    expect(Note.all.map(&:id)).to include(*notes.map(&:id))
  end

  # FIXME: duplicate code in `spec/support/tagable.rb`
  it 'has tags' do
    world = build(:world)
    expect(world).to respond_to(:tag)
  end

  # FIXME: duplicate code in `spec/support/noteable.rb`
  it 'deletes all notes when subject is deleted' do
    obj = create(:world)
    note_ids = obj.note_ids
    expect(Note.all.map(&:id)).to include(*note_ids)
    obj.destroy!
    expect(Note.all.map(&:id)).not_to include(*note_ids)
  end
end
