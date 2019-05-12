RSpec.describe 'Showing a figure', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:figure) { world.figures.first }

  context 'of an own world' do
    before(:example) { visit world_figure_path(world, figure) }

    it 'shows figure details' do
      expect(page).to have_content(figure.name)
      expect(page).to have_content(figure.description)
      expect(page)
        .to have_link(figure.world.title, href: world_path(figure.world))
    end

    it 'shows figures menu', :comprehensive do
      page.first('nav.nav') do
        expect(page).to have_link(href: new_world_figure_path(world))
        expect(page).to have_link(href: world_figures_path(world))
        expect(page).to have_link(href: edit_world_figure_path(world, figure))
        expect(page).to have_link('delete',
                                  href: world_figure_path(world, figure))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_figure_path(world, figure) }
    end

    it_behaves_like 'associated note' do
      let(:subject) { figure }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { figure }
    end
  end

  context 'with image' do
    before(:example) do
      figure.image = fixture_file_upload(fixture_file_name('figure.jpg'))
      visit world_figure_path(world, figure)
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.figure-image')
    end

  end

  context 'of another users world' do
    let(:other_figure) { other_world.figures.first }

    before(:example) { visit world_figure_path(other_world, other_figure) }

    it 'redirects to own worlds index' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
