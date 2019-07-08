RSpec.describe 'Deleting a figure', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_figures, user: user) }
  let(:other_world) { create(:world_with_figures) }
  let(:figure) { world.figures.first }
  let(:other_figure) { other_world.figures.first }

  context 'of an own world' do
    before(:example) { visit world_figure_path(world, figure) }

    it 'removes this figure', :js, :comprehensive do
      page.accept_confirm() do
        page.first('nav.context-menu a.nav-link[title="delete"]').click
      end
      expect(page).to be_i18n_ready
      expect(page).to have_current_path(world_figures_path(world))
      expect(Figure.find_by(id: figure.id)).to be_falsey
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_figure_path(world, figure) }
    end
  end

  context 'of another users world' do
    before(:example) { visit world_figure_path(other_world, other_figure) }

    it 'refuses to remove figure of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
