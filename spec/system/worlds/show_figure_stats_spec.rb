RSpec.describe 'Showing a worlds figure stats',
  type: :system, login: :user_with_worlds do

  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }

  before(:example) do
    world.figures << create(:figure, world: world, image: nil)
    visit world_path(world)
  end

  it 'shows figure stats' do
    page.within('#figure-stats') do
      expect(page).to have_content(/#{world.figures.count}\sFigure/)
    end
  end

  it 'shows figure menu' do
    page.within('#figure-stats') do
      expect(page).to have_link(href: world_figures_path(world),
                                title: 'index',
                                class: 'nav-link')
      expect(page).to have_link(href: new_world_figure_path(world),
                                title: 'new',
                                class: 'nav-link')
    end
  end

  it 'shows a list of 3 last updated figures' do
    page.within('#figure-stats') do
      expect(page).to have_selector('li[id^="last-updated-figure"]',
                                    count: 3)
    end
    nicks = world.figures.last_updated(3).map(&:nick)
    nicks.each do |nick|
      expect(page).to have_content(nick)
    end
  end

  it 'shows some details on each listed figure' do
    figure = world.figures.last_updated.first
    page.within("li[id^=\"last-updated-figure-#{figure.id}\"]") do
      expect(page).to have_content(figure.description)
      expect(page).to have_link(href: world_figure_path(world, figure), title: 'show')
    end
  end
end

