# frozen_string_literal: true

RSpec.describe Permission, type: :model do
  let(:owner)     { create(:user) }
  let(:mate)      { build_stubbed(:user) }
  let(:foreigner) { build_stubbed(:user) }
  let(:world)     { create(:world, user: owner) }

  it 'cannot be build without world, permissions and user' do
    permission = Permission.new(permissions: :rw)
    expect(permission).not_to be_valid
    expect { permission.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    permission = Permission.new(user: mate, permissions: :public)
    expect(permission).not_to be_valid
    expect { permission.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
    permission = Permission.new(world: world, user: mate)
    expect(permission).not_to be_valid
    expect { permission.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
  end

  it 'cannot be build with user who is owner', db_triggers: true do
    permission = Permission.new(world: world, user: owner, permissions: :rw)
    expect(permission).not_to be_valid
    expect { permission.save!(validate: false) }
      .to raise_error ActiveRecord::StatementInvalid
  end

  it 'can make a world public readable' do
    permission = Permission.new(world: world, user: mate, permissions: :public)
    expect(permission).to be_valid
    expect { permission.save!(validate: false) }
      .not_to raise_error
  end

  it 'can allow a specific user to show a world' do
    permission = Permission
                 .new(world: world, user: mate, permissions: :r)
    expect(permission).to be_valid
    expect { permission.save!(validate: false) }
      .not_to raise_error
  end

  it 'cannot add multiple permissions for same user and world' do
    Permission.create(world: world, user: mate, permissions: :r)
    permission = Permission.new(world: world, user: mate, permissions: :rw)
    expect(permission).not_to be_valid
    expect { permission.save!(validate: false) }
      .to raise_error ActiveRecord::StatementInvalid
  end

  it 'can allow a specific user to change a world' do
    permission = Permission.create(world: world, user: mate, permissions: :rw)
    expect(permission).to be_valid
  end

  it 'will be deleted if world is deleted', db_triggers: true do
    u = create(:user)
    perm1 = world.permissions.create(user: u, permissions: :r)
    perm2 = world.permissions.create(permissions: :public)
    expect { world.destroy }.not_to raise_error
    expect(world).to be_destroyed
    expect(Permission.find_by(id: perm1.id)).to be_falsey
    expect(Permission.find_by(id: perm2.id)).to be_falsey
  end

  it 'does not touch world if deleted', db_triggers: true do
    perm = world.permissions.create(permissions: :public)
    perm.destroy
    expect(world).to be
  end

  it 'will be deleted if user is deleted', db_triggers: true do
    u = create(:user)
    perm = world.permissions.create(user: u, permissions: :rw)
    expect { u.destroy! }.not_to raise_error
    expect(Permission.find_by(id: perm.id)).to be_falsey
  end
end
