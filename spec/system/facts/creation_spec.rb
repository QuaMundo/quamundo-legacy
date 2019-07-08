RSpec.describe 'Creating a fact', type: :system do
  include_context 'Session'

  let(:world)   { create(:world, user: user) }

  context 'in own world' do
    before(:example) { visit new_world_fact_path(world) }

    it 'is successfully with  completed form' do
      expect(world.facts.count).to eq 0
      fill_in('Name', with: 'This new fact')
      fill_in('Description', with: 'Description of new fact')
      page.attach_file('fact_image', fixture_file_name('fact.jpg'))
      # FIXME: Add start and end date
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(world.facts.count).to be > 0
      expect(page).to have_current_path(
        world_fact_path(world, Fact.find_by(name: 'This new fact'))
      )
    end

    it 'can have a start and/or an end date' do
      fill_in('Name', with: 'New Fact')
      fill_in('Start date', with: '2018-01-01 10:25')
      fill_in('End date', with: '2019-01-01 10:25')
      click_button('submit')
      expect(page).to have_content('01-01-2018 10:25')
      expect(page).to have_content('01-01-2019 10:25')
    end

    it 'refuses creation if start date is after end date' do
      fill_in('Name', with: 'Invalid fact')
      fill_in('Start date', with: '2019-12-31')
      fill_in('End date', with: '2019-01-01')
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_selector('.alert.alert-danger')
    end

    # FIXME: Entering a non-date value does not cause an error msg
    it 'refuses creation with invalid filled date field'

    it 'redirects to new if name is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: /failed to create/i)
    end
  end

  context 'in another users world' do
    let(:other_world) { create(:world_with_facts) }

    before(:example) { visit new_world_fact_path(other_world) }

    it 'redirects to worlds index' do
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                    text: /not allowed/i)
    end
  end
end
