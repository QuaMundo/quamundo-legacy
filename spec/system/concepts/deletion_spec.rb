RSpec.describe 'Deleting a concept', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_concepts, user: user) }
  let(:other_world) { create(:world_with_concepts) }
  let(:concept) { world.concepts.first }
  let(:other_concept) { other_world.concepts.first }

  context 'of an own world' do
    before(:example) { visit world_concept_path(world, concept) }

    it 'removes this concept', :js, :comprehensive do
      page.accept_confirm() do
        page.first('nav.context-menu a.nav-link[title="delete"]').click
      end
      expect(page).to have_current_path(world_concepts_path(world))
      expect(page).to be_i18n_ready
      expect(Concept.find_by(id: concept.id)).to be_falsey
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_concept_path(world, concept) }
    end
  end

  context 'oa another users world' do
    before(:example) { visit world_concept_path(other_world, other_concept) }

    it 'refuses to remove concept of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
