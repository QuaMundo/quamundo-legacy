RSpec.describe Item, type: :model do
  include_context 'Session'
  include_context 'Users'

  let(:world) { user_with_worlds.worlds.first }
  let(:item) { build(:item, world: world) }

  it 'can only be created in context of a world' do
    expect(item).to be_valid
    expect(item.world).to eq(world)
  end

  it 'is invalid without a name' do
    an_item = world.items.new
    expect(an_item).not_to be_valid
    expect { an_item.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    expect(an_item.save).to be_falsey
  end

  it 'is indirectly linked to a user' do
    item.save
    expect(user_with_worlds.items).to include(item)
    expect(item.user).to eq(user_with_worlds)
  end

  it 'can get an image attached' do
    attach_file(item.image, 'item.png')
    item.save!
    expect(item.image).to be_attached
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { item }
  end
end
