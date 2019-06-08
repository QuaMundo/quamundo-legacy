RSpec.describe 'Creating a figure', type: :system do
  include_context 'Session'

  context 'in own world' do
    let(:world) { create(:world, user: user) }

    before(:example) { visit new_world_figure_path(world) }

    it 'is successful with completed form' do
      figure_count = world.figures.count
      fill_in('Name', with: 'Figgie_new')
      fill_in('Description', with: 'New Figgies description')
      page.attach_file('figure_image', fixture_file_name('figure.jpg'))
      click_button('submit')
      expect(world.figures.count).to be > figure_count
      expect(page).to have_selector('.alert-info',
                                    text: /successfully\s+created/i)
      expect(page)
        .to have_current_path(world_figure_path(world, Figure.find_by(name: 'Figgie_new')))
    end

    it 'redirects to new form if name is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: /failed/i)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { new_world_figure_path(world) }
    end
  end

  context 'in other users world' do
    let(:other_world) { create(:world) }

    before(:example) { visit new_world_figure_path(other_world) }

    it 'redirects to worlds index' do
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                   text: 'You are not allowed')
    end
  end
end
