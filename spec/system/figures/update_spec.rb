RSpec.describe 'Updating/editing a figure', type: :system do

  include_context 'Session'

  let(:figure)        { create(:figure, user: user) }
  let(:world)         { figure.world }
  let(:other_figure)  { create(:figure)  }
  let(:other_world)   { other_figure.world }

  context 'of own world' do
    it 'can update description' do
      QuamundoTestHelpers::attach_file(
        figure.image, fixture_file_name('location.jpg'))
      visit edit_world_figure_path(world, figure)
      expect(page).to have_selector("img##{element_id(figure, 'img')}")
      fill_in('Description', with: 'New description')
      click_button('submit')
      expect(page).to have_current_path(world_figure_path(world, figure))
      figure.reload
      expect(figure.description).to eq('New description')
    end

    it 'can change name' do
      visit edit_world_figure_path(world, figure)
      fill_in('Name', with: 'A new name')
      click_button('submit')
      expect(page).to have_content('A new name')
      expect(figure.reload.name).to eq 'A new name'
    end

    it 'attaches an image', :comprehensive do
      visit edit_world_figure_path(world, figure)
      page.attach_file('figure_image', fixture_file_name('figure.jpg'))
      click_button('submit')
      expect(page).to have_current_path(world_figure_path(world, figure))
      expect(figure.reload.image).to be_attached
      expect(page).to have_selector('img.figure-image')
    end

    it 'refuse to attach non image files', :comprehensive do
      visit edit_world_figure_path(world, figure)
      page.attach_file('figure_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to have_current_path(world_figure_path(world, figure))
      expect(figure.image).not_to be_attached
      expect(page).to have_selector('.alert', text: /^Failed to update/)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_figure_path(world, figure) }
    end

    it_behaves_like 'editable tags' do
      let(:path) { edit_world_figure_path(world, figure) }
    end

    it_behaves_like 'editable traits' do
      let(:subject)     { create(:figure, :with_traits, user: user) }
    end
  end

  context 'of another users world' do
    before(:example) { visit edit_world_figure_path(other_world, other_figure) }
    it 'refuse other users worlds figure' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
