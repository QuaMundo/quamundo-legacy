# frozen_string_literal: true

RSpec.describe 'Deleting a concept', type: :system do
  include_context 'Session'

  let(:concept)       { create(:concept, user: user) }
  let(:world)         { concept.world }
  let(:other_concept) { create(:concept) }
  let(:other_world)   { other_concept.world }

  context 'of an own world' do
    before(:example) { visit world_concept_path(world, concept) }

    it 'removes this concept', :js, :comprehensive do
      page.find('.nav-item a.nav-link.dropdown').click
      page.accept_confirm do
        page.first('a.dropdown-item[title="delete"]').click
      end
      expect(page).to have_current_path(world_concepts_path(world))
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
