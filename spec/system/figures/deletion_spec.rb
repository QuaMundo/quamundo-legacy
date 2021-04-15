# frozen_string_literal: true

RSpec.describe 'Deleting a figure', type: :system do
  include_context 'Session'

  let(:figure)        { create(:figure, user: user) }
  let(:world)         { figure.world }
  let(:other_figure)  { create(:figure) }
  let(:other_world)   { other_figure.world }

  context 'of an own world' do
    before(:example) { visit world_figure_path(world, figure) }

    it 'removes this figure', :js, :comprehensive do
      page.find('.nav-item a.nav-link.dropdown').click
      page.accept_confirm do
        page.first('a.dropdown-item[title="delete"]').click
      end
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
