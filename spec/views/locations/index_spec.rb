# frozen_string_literal: true

RSpec.describe 'locations/index', type: :view do
  let(:world) { create(:world) }

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

        render(partial: 'locations/index_menu', locals: { world: world })
      end

      it 'only shows link to world' do
        expect(rendered)
          .to have_link(href: world_path(world))
        expect(rendered)
          .not_to have_link(href: new_world_location_path(world))
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

          render(partial: 'locations/index_menu', locals: { world: world })
        end

        it 'only shows link to world' do
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .not_to have_link(href: new_world_location_path(world))
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :rw)

          assign(:world, world)

          render(partial: 'locations/index_menu', locals: { world: world })
        end

        it 'shows world and new location link' do
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: new_world_location_path(world))
        end
      end
    end

    context 'owning world' do
      let(:world)   { create(:world, user: user) }

      before(:example) do
        assign(:world, world)

        render(partial: 'locations/index_menu', locals: { world: world })
      end

      it 'shows world an new location link' do
        expect(rendered)
          .to have_link(href: world_path(world))
        expect(rendered)
          .to have_link(href: new_world_location_path(world))
      end
    end
  end
end
