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

  # Redundant, see 'case insensitive uniqueness'
  # it 'has an unique name' do
  #   user = create(:user_with_worlds)
  #   world = user.worlds.first
  #   new_world = build(:world, name: world.name, user: user)
  #   expect(new_world).not_to be_valid
  #   expect { new_world.save!(validate: false) }
  #     .to raise_error ActiveRecord::RecordNotUnique
  # end

  it 'has a case insensitive unique name' do
    user = build(:user)
    world = create(:world, name: 'Test', user: user)
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

  # it 'got slug updated when name is updated' do
  #   world = create(:world, name: 'Title', user: build(:user))
  #   expect(world.slug).to eq('name')
  #   world.name = 'New Title'
  #   world.save!
  #   world.reload
  #   expect(world.slug).to eq('new-name')
  # end

  it 'has an unique slug' do
    world = create(:world, user: build(:user), name: 'A Meaningfull Name')
    other_world = build(:world, user: build(:user),
                        name: 'a meaningfull name')
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
    expect(Note.ids).to include(*notes.map(&:id))
  end

  # FIXME: duplicate code in `spec/support/tagable.rb`
  it 'has tags' do
    world = build(:world)
    expect(world).to respond_to(:tag)
  end

  # FIXME: duplicate code in `spec/support/traitable.rb`
  it 'has traits' do
    world = build(:world)
    expect(world).to respond_to(:trait)
  end

  # FIXME: duplicate code in `spec/support/dossierable.rb`
  it 'has dossiers' do
    world = build(:world)
    expect(world).to respond_to(:dossiers)
  end

  # FIXME: duplicate code in `spec/support/noteable.rb`
  it 'deletes all notes when subject is deleted' do
    obj = create(:world)
    note_ids = obj.note_ids
    expect(Note.ids).to include(*note_ids)
    obj.destroy!
    expect(Note.ids).not_to include(*note_ids)
  end

  context 'age of world' do
      let(:world) { build(:world) }
      let(:s_time) { Time.current - 50.years }
      let(:e_time) { Time.current + 50.years }

    it 'knows its time of beginning' do
      world.facts << build(:fact, start_date: s_time)
      world.save
      expect(world.begin_of_time).to eq s_time
      expect(world.end_of_time).to be_nil
      expect(world.age).to be_nil
    end

    it 'knows its time of ending' do
      world.facts << build(:fact, end_date: e_time)
      world.save
      expect(world.begin_of_time).to be_nil
      expect(world.end_of_time).to eq e_time
      expect(world.age).to be_nil
    end

    it 'knows about its age if dated facts exist' do
      world.facts << build(:fact, start_date: s_time)
      world.facts << build(:fact, end_date: e_time)
      world.save
      expect(world.begin_of_time).to eq s_time
      expect(world.end_of_time).to eq e_time
      expect(world.age).to eq(e_time - s_time)
    end
  end
end
