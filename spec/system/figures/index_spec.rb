RSpec.describe 'Listing figures', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }
  let(:other_world) { other_user_with_worlds.worlds.first }

  context 'of an own world' do
    before(:example) { visit world_figures_path(world) }

    it 'shows cards of each figure' do
      world.figures.each do |figure|
        page
          .within("div[id=\"card-figure-#{figure.id}\"]") do
          expect(page).to have_content(figure.nick)
          expect(page).to have_content(figure.description)
          expect(page).to have_link(href: world_figure_path(world, figure))
          expect(page).to have_selector(".card-img")
          expect(page).to have_content(figure.world.title)
        end
      end
    end
  end

  context 'of another users world' do
    before(:example) { visit world_figures_path(other_world) }

    it 'does not show figures of another users world' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
