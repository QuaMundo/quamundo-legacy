RSpec.describe RelationPolicy, type: :policy do
  context 'for registered users' do
    include_context 'Session'

    context 'in users own world' do
      let(:record)    { build_stubbed(:relation, user: user) }
      let(:fact)      { record.fact }
      let(:context)   { { user: user, world: fact.world, fact: fact } }

      describe_rule :new? do
        succeed "if user owns relations world"
      end

      describe_rule :update? do
        succeed "if user owns relations world"
      end

      describe_rule :show? do
        succeed "if user owns relations world"
      end

      describe_rule :index? do
        let(:fact)      { build_stubbed(:fact, user: user) }
        let(:record)    { build_stubbed_list(:relation, 2, fact: fact) }
        let(:context)   { { user: user, world: fact.world, fact: fact } }

        succeed "if user owns relations world"
      end

    end

    context 'in world not owned by user' do
      let(:record)    { build_stubbed(:relation) }
      let(:fact)      { record.fact }
      let(:world)     { fact.world }
      let(:context)   { { user: user, world: world, fact: fact } }

      describe_rule :new? do
        failed "if relations world is not owned by user"

        failed "if user does not own relations world and only may read" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :r)
          end
        end

        succeed "if user does not own world but may read-write" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :rw)
          end
        end
      end

      describe_rule :update? do
        failed "if relations world is not owned by user"

        failed "if user does not own relations world and only may read" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :r)
          end
        end

        succeed "if user does not own world but may read-write" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :rw)
          end
        end
      end

      describe_rule :show? do
        failed "if user does not own world"

        succeed "if user does not own world but may read" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :r)
          end
        end

        succeed "if user does not own world but may read-write" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :rw)
          end
        end
      end

      describe_rule :index? do
        let(:fact)      { build_stubbed(:fact) }
        let(:world)     { fact.world }
        let(:record)    { build_stubbed_list(:relation, 2, fact: fact) }
        let(:context)   { { user: user, world: world, fact: fact } }

        failed "if user does not own world"

        succeed "if user does not own world but may read" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :r)
          end
        end

        succeed "if user does not own world but may read-write" do
          before(:example) do
            Permission.create(world: world, user: user, permissions: :rw)
          end
        end
      end
    end
  end

  context 'for unregistered users' do
    let(:record)    { build_stubbed(:relation) }
    let(:fact)      { record.fact }
    let(:context)   { { world: fact.world, fact: fact } }

    describe_rule :new? do
      failed "if user ist not registerd"
    end

    describe_rule :update? do
      failed "if user ist not registerd"
    end

    describe_rule :show? do
      failed "if relations world is not public readable"

      succeed "if relations world is public readable" do
        before(:example) do
          Permission.create(world: record.fact.world, permissions: :public)
        end
      end
    end

    describe_rule :index? do
      let(:fact)      { build_stubbed(:fact) }
      let(:record)    { build_stubbed_list(:relation, 2, fact: fact) }
      let(:context)   { { world: fact.world, fact: fact } }

      failed "if relations world is not public readable"

      succeed "if dossierables world is public readable" do
        before(:example) do
          Permission.create(world: fact.world, permissions: :public)
        end
      end
    end
  end
end
