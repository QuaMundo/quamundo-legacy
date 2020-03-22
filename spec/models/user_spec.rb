require 'rails_helper'

RSpec.describe User, type: :model do
  # default user stuff doesn't need testing since it's hopefully
  # tested by devise

  let(:user) { build(:user) }

  it 'has a list of his worlds' do
    world = build(:world, name: 'My World', user: user)
    expect(user).to respond_to(:worlds)
    user.worlds << world
    expect { user.save! }.not_to raise_error
    user.reload
    expect(user.worlds).to include(world)
  end

  it 'requires a nick name' do
    user.nick = nil
    expect(user).not_to be_valid
    # Following exception is not thrown since `nick.downcase!` allready
    # throws `Method not found on nil`.
    # expect { user.save!(validate: false) }
    #   .to raise_error ActiveRecord::NotNullViolation
  end

  it 'requires nick name to be case insensitive unique' do
    user.save
    other_user = build(:user, nick: user.nick.upcase,
                       email: 'test1@example.com', password: 'pa55w05t')
    expect { other_user.save!(validate: false) }
      .to raise_error ActiveRecord::RecordNotUnique
    expect(other_user).not_to be_valid
  end

  it 'changes nick to all lowercase' do
    new_user = build(:user, nick: 'NIcKnAMe', email: 'test@example.com',
                     password: 's3cr3t')
    new_user.save!
    expect(new_user.nick).to eq('nickname')
  end

  it 'only allows a-zA-Z0-9 and .-_ chars in nick' do
    user.nick = '.ali'
    expect(user).to be_invalid
    user.nick = 'hallo & welt'
    expect(user).to be_invalid
    user.nick = 'hallo_1-welt.neu'
    expect(user).to be_valid
  end

  it 'when deleted, all worlds are deleted, too' do
    user_with_worlds = create(:user_with_worlds_wo_img, worlds_count: 3)
    worlds = user_with_worlds.world_ids
    user_with_worlds.destroy
    expect(user_with_worlds).to be_destroyed
    expect(World.find_by(id: worlds)).to be_nil
  end

  # FIXME: Add `admin` flag in future versions!
  context 'admin privileges' do
    it 'has admin privileges with user id 0' do
      admin = build(:user, id: 0)
      expect(admin.admin?).to be_truthy
    end

    it 'does not have admin privileges with a user id other than 0' do
      user = build(:user, id: 42)
      expect(user.admin?).to be_falsey
    end
  end
end
