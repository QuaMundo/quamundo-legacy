require 'rails_helper'

RSpec.describe User, type: :model do
  include_context 'Users'

  # default user stuff doesn't need testing since it's hopefully
  # tested by devise

  it 'has a list of his worlds' do
    world = build(:world, title: 'My World', user: user)
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

  # FIXME: Refactor next examples to use shaerd examples
  it 'requires nick name to be case insensitive unique' do
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
    worlds = user_with_worlds.worlds.map(&:id)
    user_with_worlds.destroy
    expect(user_with_worlds).to be_destroyed
    expect(World.find_by(id: worlds)).to be_nil
  end
end
