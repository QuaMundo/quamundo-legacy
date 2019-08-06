RSpec.describe 'Listing figures', type: :system do
  include_context 'Session'

  context 'of an own world' do
    let(:world) { create(:world_with_figures, user: user) }

    before(:example) { visit world_figures_path(world) }

    it 'shows cards of each figure' do
      world.figures.each do |figure|
        page
          .within("[id=\"figure-#{figure.id}\"]") do
          expect(page).to have_content(figure.name)
          expect(page).to have_content(figure.description)
          expect(page).to have_link(href: world_figure_path(world, figure))
          expect(page).to have_selector("img")
        end
      end
    end

    it 'shows index context menu' do
      page.first('.card-header') do
        expect(page).to have_link(href: world_path(world))
        expect(page).to have_link(href: new_world_figure_path(world))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_figures_path(world) }
    end
  end

  context 'of another users world' do
    let(:other_world) { create(:world_with_figures) }

    before(:example) { visit world_figures_path(other_world) }

    it 'does not show figures of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
