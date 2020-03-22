RSpec.describe DossierPolicy, type: :policy do
  let(:world)     { build_stubbed(:world) }
  let(:item)      { build_stubbed(:item, world: world) }

  context 'worlds dossier' do
    context 'for registered users' do
      include_context 'Session'

      context 'with users own world' do
        let(:world)     { build_stubbed(:world, user: user) }
        let(:record)    { build_stubbed(:dossier, dossierable: world) }
        let(:context)   { { user: user, world: world } }

        describe_rule :new? do
          succeed "if user owns world of dossierable"
        end

        describe_rule :update? do
          succeed "if user owns world of dossierable"
        end

        describe_rule :show? do
          succeed "if user owns world of dossierable"
        end

      end

      context 'with world not owned by user' do
        let(:world)     { build_stubbed(:world) }
        let(:record)    { build_stubbed(:dossier, dossierable: world) }
        let(:context)   { { user: user, world: world } }

        describe_rule :new? do
          succeed "if user does not own dossierables world but may write" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :rw)
            end
          end

          failed "if user does not own dossierables world and only may read" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :r)
            end
          end

          failed "if user does not own dossierables world that is public readable" do
            before(:example) do
              Permission.create(world: world, permissions: :public)
            end
          end
        end

        describe_rule :update? do
          succeed "if user does not own dossierables world but my write" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :rw)
            end
          end

          failed "if user does not own dossierables world and only may read" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :r)
            end
          end

          failed "if user does not own dossierables world that is public readable" do
            before(:example) do
              Permission.create(world: world, permissions: :public)
            end
          end
        end

        describe_rule :show? do
          succeed "if user does not own dossierables world and may read-write" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :rw)
            end
          end

          succeed "if user does not own dossierables world and may read" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :r)
            end
          end

          succeed "if user does not own dossierables world that is public readable" do
            before(:example) do
              Permission.create(world: world, permissions: :public)
            end
          end
        end
      end
    end

    context 'for unregistered users' do
      let(:record)    { build_stubbed(:dossier, dossierable: world) }
      let(:context)   { { world: world } }

      describe_rule :new? do
        failed "if dossierables world is not public readable"
      end

      describe_rule :update? do
        failed "if dossierables world is not public readable"
      end

      describe_rule :show? do
        succeed "if dossierables world is public readable" do
          before(:example) do
            Permission.create(world: world, permissions: :public)
          end
        end
      end
    end
  end

  context 'items dossier' do
    context 'for registered users' do
      include_context 'Session'

      context 'with users own world' do
        let(:world)     { build_stubbed(:world, user: user) }
        let(:record)    { build_stubbed(:dossier, dossierable: item) }
        let(:context)   { { user: user, world: world } }

        describe_rule :new? do
          succeed "if user owns world of dossierable"
        end

        describe_rule :update? do
          succeed "if user owns world of dossierable"
        end

        describe_rule :show? do
          succeed "if user owns world of dossierable"
        end

      end

      context 'with world not owned by user' do
        let(:world)     { build_stubbed(:world) }
        let(:record)    { build_stubbed(:dossier, dossierable: item) }
        let(:context)   { { user: user, world: world } }

        describe_rule :new? do
          succeed "if user does not own dossierables world but my write" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :rw)
            end
          end

          failed "if user does not own dossierables world and only may read" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :r)
            end
          end

          failed "if user does not own dossierables world that is public readable" do
            before(:example) do
              Permission.create(world: world, permissions: :public)
            end
          end
        end

        describe_rule :update? do
          succeed "if user does not own dossierables world but my write" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :rw)
            end
          end

          failed "if user does not own dossierables world and only may read" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :r)
            end
          end

          failed "if user does not own dossierables world that is public readable" do
            before(:example) do
              Permission.create(world: world, permissions: :public)
            end
          end
        end

        describe_rule :show? do
          succeed "if user does not own dossierables world and may read-write" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :rw)
            end
          end

          succeed "if user does not own dossierables world and may read" do
            before(:example) do
              Permission.create(world: world, user: user, permissions: :r)
            end
          end

          succeed "if user does not own dossierables world that is public readable" do
            before(:example) do
              Permission.create(world: world, permissions: :public)
            end
          end
        end
      end
    end

    context 'for unregistered users' do
      let(:record)    { build_stubbed(:dossier, dossierable: item) }
      let(:context)   { { world: world } }

      describe_rule :new? do
        failed "if dossierables world is not public readable"
      end

      describe_rule :update? do
        failed "if dossierables world is not public readable"
      end

      describe_rule :show? do
        succeed "if dossierables world is public readable" do
          before(:example) do
            Permission.create(world: world, permissions: :public)
          end
        end
      end
    end
  end
end
