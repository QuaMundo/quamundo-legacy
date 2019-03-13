RSpec.describe 'Updating/editing a figure',
  type: :system, login: :user_with_worlds do

  include_context 'Session'
  include_context 'Worlds'

  let(:world) { user_with_worlds.worlds.first }
  let(:figure) { world.figures.first }
  let(:other_world) { other_user_with_worlds.worlds.first }
  let(:other_figure) { other_world.figures.first }

  context 'of own world' do
    before(:example) { visit edit_world_figure_path(world, figure) }

    it 'can update last name, first name and description' do
      fill_in('Lastname', with: 'New Last Name')
      fill_in('Firstname', with: 'New First Name')
      fill_in('Description', with: 'New description')
      click_button('submit')
      expect(current_path).to eq(world_figure_path(world, figure))
      figure.reload
      expect(figure.last_name).to eq('New Last Name')
      expect(figure.first_name).to eq('New First Name')
      expect(figure.description).to eq('New description')
    end

    it 'refuses to change nick' do
      expect(page)
        .to have_selector('input[type="text"][name="figure[nick]"][disabled]')
    end

    it 'attaches an image', :comprehensive do
      page.attach_file('figure_image', fixture_file_name('figure.png'))
      click_button('submit')
      expect(current_path).to eq(world_figure_path(world, figure))
      expect(figure.image).to be_attached
      expect(page).to have_selector('img.figure-image')
    end

    it 'refuse to attach non image files', :comprehensive do
      page.attach_file('figure_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(current_path).to eq(world_figure_path(world, figure))
      expect(figure.image).not_to be_attached
      pending("First find out how errors and flash work")
      expect(page).to have_selector('.alert', text: 'Only images may be')
    end
  end

  context 'of another users world' do
    before(:example) { visit edit_world_figure_path(other_world, other_figure) }
    it 'refuse other users worlds figure' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
