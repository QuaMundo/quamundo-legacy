RSpec.describe 'Creating a figure', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }

  context 'in own world' do
    before(:example) { visit new_world_figure_path(world) }

    it 'is successful with completed form' do
      figure_count = world.figures.count
      fill_in('Nick', with: 'Figgie_new')
      fill_in('Lastname', with: 'New Figure')
      fill_in('Firstname', with: 'New Figgie')
      fill_in('Description', with: 'New Figgies description')
      page.attach_file('figure_image', fixture_file_name('figure.png'))
      click_button('submit')
      expect(world.figures.count).to be > figure_count
      expect(page).to have_selector('.alert-info',
                                    text: 'Figure figgie_new successfully created')
      expect(current_path)
        .to eq(world_figure_path(world, Figure.find_by(nick: 'figgie_new')))
    end

    it 'redirects to new form if nick is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: 'Nick')
    end

    it_behaves_like 'valid_view' do
      let(:subject) { new_world_figure_path(world) }
    end
  end

  context 'in other users world' do
    let(:other_world) { other_user_with_worlds.worlds.first }

    before(:example) { visit new_world_figure_path(other_world) }

    it 'redirects to worlds index' do
      expect(current_path).to eq(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                   text: 'You are not allowed')
    end
  end
end
