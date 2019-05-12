RSpec.describe 'Listing figures', type: :system, login: :user_with_worlds do
  include_context 'Session'

  context 'of an own world' do
    before(:example) { visit world_figures_path(world) }

    it 'shows cards of each figure' do
      world.figures.each do |figure|
        page
          .within("div[id=\"card-figure-#{figure.id}\"]") do
          expect(page).to have_content(figure.name)
          expect(page).to have_content(figure.description)
          expect(page).to have_link(href: world_figure_path(world, figure))
          expect(page).to have_selector(".card-img")
          expect(page).to have_content(figure.world.title)
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
    before(:example) { visit world_figures_path(other_world) }

    it 'does not show figures of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
