# frozen_string_literal: true

RSpec.describe 'Creating a fact', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }

  context 'in own world' do
    before(:example) { visit new_world_fact_path(world) }

    it 'is successfully with  completed form' do
      expect(world.facts.count).to eq 0
      fill_in('Name', with: 'This new fact')
      fill_in('Description', with: 'Description of new fact')
      page.attach_file('fact_image', fixture_file_name('fact.jpg'))
      fill_in('Start date', with: '2018-01-01 10:25')
      fill_in('End date', with: '2019-01-01 10:25')
      click_button('submit')
      expect(world.facts.count).to be > 0
      expect(page).to have_current_path(
        world_fact_path(world, Fact.find_by(name: 'This new fact'))
      )
    end

    context 'with given start and end date' do
      it 'can process format "yyyy-mm-dd hh:MM"' do
        fill_in('Name', with: 'New Fact')
        fill_in('Start date', with: '2018-01-01 10:25')
        fill_in('End date', with: '2019-01-01 10:25')
        click_button('submit')
        expect(page).to have_content(/January 01, 2018 10:25/)
        expect(page).to have_content(/January 01, 2019 10:25/)
      end

      it 'can process format "dd.mm.yyyy hh:MM"' do
        fill_in('Name', with: 'New Fact')
        fill_in('Start date', with: '01.01.2018 10:25')
        fill_in('End date', with: '01.01.2019 10:25')
        click_button('submit')
        expect(page).to have_content(/January 01, 2018 10:25/)
        expect(page).to have_content(/January 01, 2019 10:25/)
      end
    end

    it 'refuses creation if start date is after end date' do
      fill_in('Name', with: 'Invalid fact')
      fill_in('Start date', with: '2019-12-31')
      fill_in('End date', with: '2019-01-01')
      click_button('submit')
      expect(page).to have_selector('.alert.alert-danger')
    end

    # FIXME: Entering a non-date value does not cause an error msg
    it 'refuses creation with invalid filled date field'

    it 'redirects to new if name is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: /failed to create/i)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { new_world_fact_path(world) }
    end

    it_behaves_like 'editable tags' do
      let(:path)    { new_world_fact_path(world) }
    end

    it_behaves_like 'creatable traits' do
      let(:path)      { new_world_fact_path(world) }
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
