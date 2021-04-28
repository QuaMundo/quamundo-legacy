# frozen_string_literal: true

RSpec.describe 'figures/index', type: :view do
  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:figure)    { create(:figure, user: user) }
      let(:world)     { figure.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render partial: 'figures/index_entry', locals: { index_entry: figure }
      end

      it 'shows a figure index entry' do
        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{figure.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description',
                            text: /#{figure.description}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{figure.facts.count}/
        expect(rendered).to match /#{figure.relatives.count}/

        expect(rendered)
          .to have_link(href: world_figure_path(world, figure))
        expect(rendered)
          .to have_link(href: edit_world_figure_path(world, figure))
        expect(rendered)
          .to have_link(href: world_figure_path(world, figure),
                        id: /delete-.+/)
      end
    end

    context 'not owning world' do
      let(:figure)    { create(:figure) }
      let(:world)     { figure.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)
      end

      it 'does not show crud links with read permission only' do
        Permission.create(world: world, user: user, permissions: :r)

        render partial: 'figures/index_entry', locals: { index_entry: figure }

        expect(rendered)
          .not_to have_link(href: edit_world_figure_path(world, figure))
        expect(rendered)
          .not_to have_link(href: world_figure_path(world, figure),
                            title: 'delete')
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'figures/index_entry', locals: { index_entry: figure }

        expect(rendered)
          .to have_link(href: edit_world_figure_path(world, figure))
        expect(rendered)
          .to have_link(href: world_figure_path(world, figure),
                        title: 'delete')
      end
    end
  end

  context 'unregistered user not owning public readable world' do
    let(:figure)    { create(:figure) }
    let(:world)     { figure.world }

    before(:example) do
      Permission.create(world: world, permissions: :public)

      # FIXME: `current_world` doesn't seem to be available, so work around ...
      controller.class.class_eval { include WorldAssociationController }
      allow(controller).to receive(:current_world).and_return(world)

      render partial: 'figures/index_entry', locals: { index_entry: figure }
    end

    it 'does not render crud links' do
      expect(rendered)
        .not_to have_link(href: edit_world_figure_path(world, figure))
      expect(rendered)
        .not_to have_link(href: world_figure_path(world, figure),
                          title: 'delete')
    end
  end
end
