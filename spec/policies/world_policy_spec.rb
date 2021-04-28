# frozen_string_literal: true

RSpec.describe WorldPolicy, type: :policy do
  context 'for registered user' do
    include_context 'Session'

    describe_rule :new? do
      succeed 'if user is logged in' do
        let(:context)   { { user: user } }
      end
    end

    describe_rule :create? do
      succeed 'if user is logged in' do
        let(:context)   { { user: user } }
      end
    end

    describe_rule :edit? do
      succeed 'if user is owner' do
        let(:record)    { build_stubbed(:world, user: user) }
        let(:context)   { { user: user, world: record } }
      end

      failed 'if user is not owner and has no permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
      end

      failed 'if user is not owner and only has read permission' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :r)
        end
      end

      succeed 'if user is not owner but has read-write permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :rw)
        end
      end
    end

    describe_rule :update? do
      succeed 'if user is owner' do
        let(:record)    { build_stubbed(:world, user: user) }
        let(:context)   { { user: user, world: record } }
      end

      failed 'if user is not owner and has no permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
      end

      failed 'if user is not owner and only has read permission' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :r)
        end
      end

      succeed 'if user is not owner but has read-write permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :rw)
        end
      end
    end

    describe_rule :destroy? do
      succeed 'if user is owner' do
        let(:record)    { build_stubbed(:world, user: user) }
        let(:context)   { { user: user, world: record } }
      end

      failed 'if user is not owner and has no permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { {  user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :r)
        end
      end

      failed 'if user is not owner and only has read permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :r)
        end
      end

      failed 'if user is not owner but has read-write permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :rw)
        end
      end
    end

    describe_rule :show? do
      succeed 'if user owns world' do
        let(:record)    { build_stubbed(:world, user: user) }
        let(:context)   { { user: user, world: record } }
      end

      failed 'if user is not owner and has no permissions' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
      end

      succeed 'if user is not owner but may read' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :r)
        end
      end

      succeed 'if user is not owner but may read and write' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { user: user, world: record } }
        before(:example) do
          Permission.create(user: user, world: record, permissions: :rw)
        end
      end
    end

    describe_rule :index?
  end

  context 'for unregistered users' do
    describe_rule :new? do
      failed 'if user is not registered' do
        let(:context) { { user: nil } }
      end
    end

    describe_rule :create? do
      failed 'if user is not registered' do
        let(:context)   { { user: nil } }
      end
    end

    describe_rule :edit? do
      failed 'if user is not registered' do
        let(:context)   { { user: nil } }
      end
    end

    describe_rule :update? do
      failed 'if user is not registered' do
        let(:context)   { { user: nil } }
      end
    end

    describe_rule :destroy? do
      failed 'if user is not registered' do
        let(:context)   { { user: nil } }
      end
    end

    describe_rule :show? do
      succeed 'if world is public readable' do
        let(:record)    { build_stubbed(:world) }
        let(:context)   { { world: record } }
        before(:example) do
          Permission.create(world: record, permissions: :public)
        end
      end
    end

    describe_rule :index? do
      let(:record) { create_list(:world, 2) }

      failed 'if there is a world that is not public readable' do
        before(:example) do
          Permission.create(world: record.first, permissions: :public)
        end
      end

      succeed 'if all worlds are public readable' do
        before(:example) do
          record.each do |w|
            Permission.create(world: w, permissions: :public)
          end
        end
      end
    end
  end
end
