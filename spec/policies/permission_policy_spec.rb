RSpec.describe PermissionPolicy, type: :policy do
  context 'for registered users' do
    include_context 'Session'

    describe_rule :update? do
      succeed "if user owns world" do
        let(:context) do
          { user: user, world: build_stubbed(:world, user: user) }
        end
      end

      failed "if user does not own world" do
        let(:context) { { user: user, world: build_stubbed(:world) } }
      end

      failed "if no world is given" do
        let(:context) { { user: user } }
      end
    end
  end

  context 'for unregistered users' do
    let(:world)   { build_stubbed(:world) }
    let(:contex)  { { user: nil, world: world } }

    describe_rule :update? do
      failed "if user is not registered"
    end
  end
end
