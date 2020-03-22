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
    permissions = Permission.new(world: world, user: mate)
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

  it 'cann allow a specific user to change a world' do
    permission = Permission.create(world: world, user: mate, permissions: :rw)
    expect(permission).to be_valid
  end
end
