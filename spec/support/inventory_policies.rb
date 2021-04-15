# frozen_string_literal: true

RSpec.shared_examples 'inventory policies', type: :policy do
  let(:policeable) do
    # According to api docs KlassPolicy.identifier is :klass
    # This is what we need for factoring sample objects (via
    # factory_bot), so ...
    described_class.identifier
  end

  context 'for registered users' do
    include_context 'Session'

    context 'with users own world' do
      let(:world)     { build_stubbed(:world, user: user) }
      let(:record)    { build_stubbed(policeable, world: world) }
      let(:context)   { { world: world, user: user } }

      describe_rule :new? do
        succeed 'if user owns described objects world'
      end

      describe_rule :update? do
        succeed 'if user owns described objects world'
      end

      describe_rule :show? do
        succeed 'if user owns described objects world'
      end

      describe_rule :index? do
        let(:record) { build_stubbed_list(policeable, 2, world: world) }
        succeed 'if user owns described objects world'
      end
    end

    context 'with world not owned by user' do
      let(:world)     { build_stubbed(:world) }
      let(:record)    { build_stubbed(policeable, world: world) }
      let(:context)   { { world: world, user: user } }

      describe_rule :new? do
        succeed 'if user does not own world but has read-write permissions' do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :rw)
          end
        end

        failed 'if user does not own world and has no permissions'

        failed 'if user does not own world and has only read permissions' do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :r)
          end
        end

        failed 'if user does not own world and world is public readable' do
          before(:example) do
            Permission.create(world: world, permissions: :public)
          end
        end
      end

      describe_rule :update? do
        succeed 'if user does not own world but has read-write permissions' do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :rw)
          end
        end

        failed 'if user does not own world and has no permissions'

        failed 'if user does not own world and has only read permissions' do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :r)
          end
        end

        failed 'if user does not own world and world is public readable' do
          before(:example) do
            Permission.create(world: world, permissions: :public)
          end
        end
      end

      describe_rule :show? do
        succeed 'if user does not own world but has read permissions' do
          before(:example) do
            Permission.create(user: user, world: world, permissions: :r)
          end
        end

        succeed 'if user does not own world but has read-write permissions' do
          before(:example) do
            Permission.create(user: user, world: world, permissions: :rw)
          end
        end

        succeed 'if user does not own world but world is public readable' do
          before(:example) do
            Permission.create(world: world, permissions: :public)
          end
        end

        failed 'if user does not own world and has no permissions'
      end

      describe_rule :index? do
        let(:record) { build_stubbed_list(policeable, 2, world: world) }

        succeed 'if user does not now world but has read permissions' do
          before(:example) do
            Permission.create(user: user, world: world, permissions: :r)
          end
        end

        succeed 'if user does not own world but has read-write permissions' do
          before(:example) do
            Permission.create(user: user, world: world, permissions: :rw)
          end
        end

        succeed 'if user does not own world but world is public readable' do
          before(:example) do
            Permission.create(world: world, permissions: :public)
          end
        end

        failed 'if user does not owm world and has no permissions'
      end
    end
  end

  context 'for unregistered users' do
    let(:world)     { build_stubbed(:world) }
    let(:record)    { build_stubbed(policeable, world: world) }
    let(:context)   { { user: nil, world: world } }

    describe_rule :new? do
      failed 'if user is not registered'
    end

    describe_rule :update? do
      failed 'if user is not registered'
    end

    describe_rule :show? do
      succeed 'if described objects world is public readable' do
        before(:example) do
          Permission.create(world: record.world, permissions: :public)
        end
      end

      failed 'if described objects world is not public readable'
    end

    describe_rule :index? do
      let(:record) { build_stubbed_list(policeable, 2, world: world) }

      succeed 'if described objects world is public readable' do
        before(:example) do
          Permission.create(world: world, permissions: :public)
        end
      end

      failed 'if described objects world is not public readable'
    end
  end
end
