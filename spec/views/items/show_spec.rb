# frozen_string_literal: true

RSpec.describe 'items/show', type: :view do
  let(:item)      { create(:item) }
  let(:world)     { item.world }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)

    assign(:item, item)
    assign(:world, world)
  end

  context 'unregistered user' do
    context 'public readable world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'shows only world and index link' do
        render
        expect(rendered)
          .to have_link(href: world_path(world))
        expect(rendered)
          .to have_link(href: world_items_path(world))
        expect(rendered)
          .not_to have_link(href: edit_world_item_path(world, item))
        expect(rendered)
          .not_to have_link(href: new_world_item_path(world))
        expect(rendered)
          .not_to have_link(href: world_item_path(world, item),
                            title: 'delete')
      end
    end

    context 'non public readable world' do
    end
  end

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:item)    { create(:item, user: user) }
    end

    context 'not owning world' do
      context 'without permissions' do
        # FIXME: This should not render at all!
        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_items_path(world))
          expect(rendered)
            .not_to have_link(href: edit_world_item_path(world, item))
          expect(rendered)
            .not_to have_link(href: new_world_item_path(world))
          expect(rendered)
            .not_to have_link(href: world_item_path(world, item),
                              title: 'delete')
        end
      end

      context 'with read permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :r)
        end

        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_items_path(world))
          expect(rendered)
            .not_to have_link(href: edit_world_item_path(world, item))
          expect(rendered)
            .not_to have_link(href: new_world_item_path(world))
          expect(rendered)
            .not_to have_link(href: world_item_path(world, item),
                              title: 'delete')
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :rw)
        end

        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_items_path(world))
          expect(rendered)
            .to have_link(href: edit_world_item_path(world, item))
          expect(rendered)
            .to have_link(href: new_world_item_path(world))
          expect(rendered)
            .to have_link(href: world_item_path(world, item),
                          title: 'delete')
        end
      end
    end
  end
end
