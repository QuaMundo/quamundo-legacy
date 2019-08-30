RSpec.describe 'Showing a figure', type: :system do
  include_context 'Session'

  let(:figure)  { create(:figure, user: user) }
  let(:world)   { figure.world }

  context 'of an own world' do
    before(:example) { visit world_figure_path(world, figure) }

    it 'shows figure details' do
      expect(page).to have_content(figure.name)
      expect(page).to have_content(figure.description)
      expect(page)
        .to have_link(figure.world.name, href: world_path(figure.world))
    end

    it 'shows figures menu', :comprehensive do
      page.first('.nav') do
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
      let(:subject) { create(:figure_with_notes, world: world) }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { figure }
    end

    it_behaves_like 'associated traits' do
      let(:subject) { create(:figure_with_traits, world: world) }
    end

    it_behaves_like 'associated dossiers' do
      let(:subject) { create(:figure_with_dossiers, user: user) }
    end

    it_behaves_like 'associated facts' do
      let(:subject) { create(:figure_with_facts, facts_count: 3, world: world) }
      let(:path)    { world_figure_path(subject.world, subject) }
    end

    it_behaves_like 'associated relations' do
      let(:subject) { create(:figure, world: world) }
    end
  end

  context 'with image' do
    before(:example) do
      figure.image = fixture_file_upload(fixture_file_name('figure.jpg'))
      figure.save
      visit world_figure_path(world, figure)
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.figure-image')
    end

  end

  context 'of another users world' do
    let(:other_world) { create(:world_with_figures) }
    let(:other_figure) { other_world.figures.first }

    before(:example) { visit world_figure_path(other_world, other_figure) }

    it 'redirects to own worlds index' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
