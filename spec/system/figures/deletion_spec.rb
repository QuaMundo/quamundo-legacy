RSpec.describe 'Deleting a figure', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.last }
  let(:other_world) { other_user_with_worlds.worlds.last }
  let(:figure) { world.figures.first }
  let(:other_figure) { other_world.figures.first }

  context 'of an own world' do
    before(:example) { visit world_figure_path(world, figure) }

    it 'removes this figure', :js, :comprehensive do
      page.accept_confirm() do
        page.find('nav.context-menu a.nav-link[title="delete"]').click
      end
      expect(current_path).to eq(world_figures_path(world))
      expect(Figure.find_by(id: figure.id)).to be_falsey
    end
  end

  context 'of another users world' do
    before(:example) { visit world_figure_path(other_world, other_figure) }

    it 'refuses to remove figure of another users world' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
