RSpec.describe 'Updating/Editing a fact', type: :system do
  include_context 'Session'

  let(:fact)  { create(:fact, user: user) }
  let(:world) { fact.world }

  context 'of own world' do
    before(:example)  { visit edit_world_fact_path(world, fact) }

    it 'can update name and description' do
      fill_in('Name', with: 'Edited fact name')
      fill_in('Description', with: 'Edited description')
      click_button('submit')
      fact.reload
      expect(page).to have_current_path(world_fact_path(world, fact))
      expect(fact.name).to eq('Edited fact name')
      expect(fact.description).to eq('Edited description')
      expect(page).to have_content('Edited fact name')
      expect(page).to have_content('Edited description')
    end

    it 'refuses to update if start date is after end date' do
      fill_in('Start date', with: '2019-12-31')
      fill_in('End date', with: '2019-01-01')
      click_button('submit')
      expect(page).to have_selector('.alert.alert-danger')
    end

    it 'attaches an image', :comprehensive do
      page.attach_file('fact_image', fixture_file_name('fact.jpg'))
      click_button('submit')
      expect(page).to have_current_path(world_fact_path(world, fact))
      expect(page).to have_selector('img.fact-image')
      expect(fact.reload.image).to be_attached
    end

  it 'refuses to attach non image files', :comprehensive do
    page.attach_file('fact_image', fixture_file_name('file.pdf'))
    click_button('submit')
    expect(page).to have_current_path(world_fact_path(world, fact))
    expect(fact.image).not_to be_attached
      expect(page).to have_selector('.alert', text: /^Failed to update/)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_fact_path(world, fact) }
    end

    it_behaves_like 'editable tags' do
      let(:path)    { edit_world_fact_path(world, fact) }
    end

    it_behaves_like 'editable traits' do
      let(:subject)     { create(:fact, :with_traits, user: user) }
    end
  end

  context 'of another users world' do
    let(:other_world) { create(:world_with_facts) }
    let(:other_fact)  { other_world.facts.first }

    before(:example)  { visit edit_world_fact_path(other_world, other_fact) }

    it 'redirects to worlds index' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
