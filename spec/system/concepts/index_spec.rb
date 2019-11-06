RSpec.describe 'Listing concepts', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_concepts, user: user) }
  let(:other_world) { create(:world_with_concepts) }

  context 'of an own world' do
    before(:example) { visit world_concepts_path(world) }

    it 'shows cards of each concept' do
      world.concepts.each do |concept|
        expect(page)
          .to have_selector("[id=\"index-entry-concept-#{concept.id}\"]")
      end
    end

    it 'shows index context menu' do
      page.first('.card-header') do
        expect(page).to have_link(href: world_path(world))
        expect(page).to have_link(href: new_world_concept_path(world))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_concepts_path(world) }
    end
  end

  context 'of another users world' do
    before(:example) { visit world_concepts_path(other_world) }

    it 'does not show concepts of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end

