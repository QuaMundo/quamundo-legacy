RSpec.describe 'Updating/editing a figure', type: :system do

  include_context 'Session'

  let(:world) { create(:world_with_figures, user: user) }
  let(:other_world) { create(:world_with_figures) }
  let(:figure) { world.figures.first }
  let(:other_figure) { other_world.figures.first }

  context 'of own world' do
    before(:example) { visit edit_world_figure_path(world, figure) }

    it 'can update description' do
      # FIXME: Duplicate action below
      QuamundoTestHelpers::attach_file(
        figure.image, fixture_file_name('location.jpg'))
      visit edit_world_figure_path(world, figure)
      expect(page).to have_selector("img##{element_id(figure, 'img')}")
      fill_in('Description', with: 'New description')
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_current_path(world_figure_path(world, figure))
      figure.reload
      expect(figure.description).to eq('New description')
    end

    it 'refuses to change name' do
      expect(page)
        .to have_selector('input[type="text"][name="figure[name]"][disabled]')
    end

    it 'attaches an image', :comprehensive do
      page.attach_file('figure_image', fixture_file_name('figure.jpg'))
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_current_path(world_figure_path(world, figure))
      expect(figure.image).to be_attached
      expect(page).to have_selector('img.figure-image')
    end

    it 'refuse to attach non image files', :comprehensive do
      page.attach_file('figure_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_current_path(world_figure_path(world, figure))
      expect(figure.image).not_to be_attached
      pending("First find out how errors and flash work")
      expect(page).to have_selector('.alert', text: 'Only images may be')
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_figure_path(world, figure) }
    end
  end

  context 'of another users world' do
    before(:example) { visit edit_world_figure_path(other_world, other_figure) }
    it 'refuse other users worlds figure' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
