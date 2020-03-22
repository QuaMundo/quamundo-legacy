RSpec.describe 'figure_ancestors/index', db_triggers: true, type: :view do
  let(:figure)          { create(:figure) }
  let!(:figureancestor) { create(:figure_ancestor, figure: figure) }
  let(:ancestor)        { figureancestor.ancestor }
  let(:world)           { figure.world }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)
  end

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:figure)        { create(:figure, user: user) }

      it 'shows crud links' do
        render(partial: 'figure_ancestors/index_entry',
               locals: { index_entry: figure.pedigree.first })

        expect(rendered)
          .to have_link(href: edit_world_figure_path(world, ancestor))
        expect(rendered).to have_link(
          href: world_figure_path(world, ancestor), title: 'delete'
        )
      end
    end

    context 'not owning world' do
      it 'does not show crud links with read permissions only' do
        Permission.create(world: world, user: user, permissions: :r)

        render(partial: 'figure_ancestors/index_entry',
               locals: { index_entry: figure.pedigree.first })

        expect(rendered)
          .not_to have_link(href: edit_world_figure_path(world, ancestor))
        expect(rendered).not_to have_link(
          href: world_figure_path(world, ancestor), title: 'delete'
        )
      end

      it 'shows crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render(partial: 'figure_ancestors/index_entry',
               locals: { index_entry: figure.pedigree.first })

        expect(rendered)
          .to have_link(href: edit_world_figure_path(world, ancestor))
        expect(rendered).to have_link(
          href: world_figure_path(world, ancestor), title: 'delete'
        )
      end
    end
  end

  context 'unregistered user with public readable world' do
    it 'does not show crud links' do
      Permission.create(world: world, permissions: :public)

      render(partial: 'figure_ancestors/index_entry',
             locals: { index_entry: figure.pedigree.first })

      expect(rendered)
        .not_to have_link(href: edit_world_figure_path(world, ancestor))
      expect(rendered).not_to have_link(
        href: world_figure_path(world, ancestor), title: 'delete'
      )
    end
  end
end
