RSpec.describe 'relations/index', type: :view do
  let(:world)     { create(:world) }
  let(:fact)      { create(:fact, world: world) }
  # let(:relations) { create_list(:relation, 2, fact: fact) }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)
  end

  context 'unregistered user' do
    context 'public readable world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)

        assign(:world, world)
        assign(:fact, fact)

        render(
          partial: 'relations/index_menu',
          locals: { world: world, fact: fact }
        )
      end

      it 'only shows link to world and fact' do
        expect(rendered)
          .to have_link(href: world_path(world))
        expect(rendered)
          .to have_link(href: world_fact_path(world, fact))
        expect(rendered)
          .not_to have_link(href: new_world_fact_relation_path(world, fact))
      end
    end

    context 'non public readable world' do
      # This should not be rendered at all
    end
  end

  context 'registerd user' do
    include_context 'Session'

    context 'not owning world' do
      context 'without permissions' do
        # this should not be rendered at all
      end

      context 'with read permissions' do
        before(example) do
          Permission.create(user: user, world: world, permissions: :r)

          assign(:world, world)
          assign(:fact, fact)

          render(
            partial: 'relations/index_menu',
            locals: { world: world, fact: fact }
          )
        end

        it 'only shows link to world and fact' do
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_fact_path(world, fact))
          expect(rendered)
            .not_to have_link(href: new_world_fact_relation_path(world, fact))
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user:user, world: world, permissions: :rw)

          assign(:world, world)
          assign(:fact, fact)

          render(
            partial: 'relations/index_menu',
            locals: { world: world, fact: fact }
          )
        end

        it 'shows world and new relation link' do
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_fact_path(world, fact))
          expect(rendered)
            .to have_link(href: new_world_fact_relation_path(world, fact))
        end
      end
    end

    context 'owning world' do
      let(:world)   { create(:world, user: user) }

      before(:example) do
        assign(:world, world)
        assign(:fact, fact)

        render(
          partial: 'relations/index_menu',
          locals: { world: world, fact: fact }
        )
      end

      it 'shows world, fact and new relation link' do
        expect(rendered)
          .to have_link(href: world_path(world))
        expect(rendered)
          .to have_link(href: world_fact_path(world, fact))
        expect(rendered)
          .to have_link(href: new_world_fact_relation_path(world, fact))
      end
    end
  end
end


