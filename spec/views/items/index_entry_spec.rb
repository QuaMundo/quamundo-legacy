# frozen_string_literal: true

RSpec.describe 'items/index', type: :view do
  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:item)    { create(:item, user: user) }
      let(:world)     { item.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render partial: 'items/index_entry', locals: { index_entry: item }
      end

      it 'shows a item index entry' do
        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{item.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description',
                            text: /#{item.description}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{item.facts.count}/
        expect(rendered).to match /#{item.relatives.count}/

        expect(rendered)
          .to have_link(href: world_item_path(world, item))
        expect(rendered)
          .to have_link(href: edit_world_item_path(world, item))
        expect(rendered)
          .to have_link(href: world_item_path(world, item),
                        id: /delete-.+/)
      end
    end

    context 'not owning world' do
      let(:item) { create(:item) }
      let(:world) { item.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)
      end

      it 'does not show crud links with read permission only' do
        Permission.create(world: world, user: user, permissions: :r)

        render partial: 'items/index_entry', locals: { index_entry: item }

        expect(rendered)
          .not_to have_link(href: edit_world_item_path(world, item))
        expect(rendered)
          .not_to have_link(href: world_item_path(world, item),
                            title: 'delete')
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'items/index_entry', locals: { index_entry: item }

        expect(rendered)
          .to have_link(href: edit_world_item_path(world, item))
        expect(rendered)
          .to have_link(href: world_item_path(world, item),
                        title: 'delete')
      end
    end
  end

  context 'unregistered user not owning public readable world' do
    let(:item) { create(:item) }
    let(:world) { item.world }

    before(:example) do
      Permission.create(world: world, permissions: :public)

      # FIXME: `current_world` doesn't seem to be available, so work around ...
      controller.class.class_eval { include WorldAssociationController }
      allow(controller).to receive(:current_world).and_return(world)

      render partial: 'items/index_entry', locals: { index_entry: item }
    end

    it 'does not render crud links' do
      expect(rendered)
        .not_to have_link(href: edit_world_item_path(world, item))
      expect(rendered)
        .not_to have_link(href: world_item_path(world, item),
                          title: 'delete')
    end
  end
end
