RSpec.describe 'Updating/Editing an concept', type: :system do
  include_context 'Session'

  let(:concept)       { create(:concept, user: user) }
  let(:world)         { concept.world }
  let(:other_concept) { create(:concept) }
  let(:other_world)   { other_concept.world }

  context 'of own world' do
    before(:example) { visit edit_world_concept_path(world, concept) }

    it 'can update name and description' do
      # FIXME: Duplicate action below
      QuamundoTestHelpers::attach_file(
        concept.image, fixture_file_name('concept.jpg'))
      visit edit_world_concept_path(world, concept)
      expect(page).to have_selector("img##{element_id(concept, 'img')}")
      fill_in('Name', with: 'New Name')
      fill_in('Description', with: 'New Description')
      click_button('submit')
      concept.reload
      expect(page).to have_current_path(world_concept_path(world, concept))
      expect(concept.name).to eq('New Name')
      expect(concept.description).to eq('New Description')
      expect(page).to have_content('New Name')
      expect(page).to have_content('New Description')
    end

    it 'attaches an image', :comprehensive do
      page.attach_file('concept_image', fixture_file_name('concept.jpg'))
      click_button('submit')
      expect(page).to have_current_path(world_concept_path(world, concept))
      concept.reload
      expect(concept.image).to be_attached
      expect(page).to have_selector('img.concept-image')
    end

    it 'refuses to attach non image files', :comprehensive do
      page.attach_file('concept_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to have_current_path(world_concept_path(world, concept))
      expect(concept.image).not_to be_attached
      #pending("Show view not yet implemented")
      # FIXME: Check for proper error msg
      expect(page).to have_selector('.alert')
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_concept_path(world, concept) }
    end

    it_behaves_like 'editable tags' do
      let(:path)    { edit_world_concept_path(world, concept) }
    end

    it_behaves_like 'editable traits' do
      let(:path)    { edit_world_concept_path(world, concept) }
    end
  end

  context 'of another users world' do
    before(:example) { visit edit_world_concept_path(other_world, other_concept) }

    it 'refuse other users worlds concept' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end

