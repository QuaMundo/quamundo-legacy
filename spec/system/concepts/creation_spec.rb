# frozen_string_literal: true

RSpec.describe 'Creating a concept', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_concepts, user: user) }

  context 'in own world' do
    before(:example) { visit new_world_concept_path(world) }

    it 'is successfull with completed form' do
      concept_count = world.concepts.count
      fill_in('Name', with: 'A new concept')
      fill_in('Description', with: 'A new concept description')
      page.attach_file('concept_image', fixture_file_name('concept.jpg'))
      click_button('submit')
      expect(world.concepts.count).to be > concept_count
      expect(page).to have_selector('.alert-info',
                                    text: /successfully\s+created/i)
      expect(page)
        .to have_current_path(
          world_concept_path(world, Concept.find_by(name: 'A new concept'))
        )
    end

    it 'redirects to new form if name is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: /failed to create/i)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { new_world_concept_path(world) }
    end

    it_behaves_like 'editable tags' do
      let(:path)    { new_world_concept_path(world) }
    end

    it_behaves_like 'creatable traits' do
      let(:path)    { new_world_concept_path(world) }
    end
  end

  context 'in other users world'
end
