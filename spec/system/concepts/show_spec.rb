RSpec.describe 'Showing an concept', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_concepts, user: user) }
  let(:other_world) { create(:world_with_concepts) }
  let(:concept) { world.concepts.first }

  context 'of an own world' do
    before(:example) { visit world_concept_path(world, concept) }

    it 'shows concept details' do
      expect(page).to have_content(concept.name)
      expect(page).to have_content(concept.description)
      expect(page)
        .to have_link(concept.world.title, href: world_path(world))
    end

    it 'shows concept menu', :comprehensive do
      page.first('nav.nav') do
        expect(page).to have_link(href: new_world_concept_path(world))
        expect(page).to have_link(href: world_concepts_path(world))
        expect(page).to have_link(href: edit_world_concept_path(world, concept))
        expect(page).to have_link('delete',
                                  href: world_concept_path(world, concept))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_concept_path(world, concept) }
    end

    it_behaves_like 'associated note' do
      let(:subject) { create(:concept_with_notes, world: world) }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { concept }
    end

    it_behaves_like 'associated traits' do
      let(:subject) { create(:concept_with_traits, world: world) }
    end

    it_behaves_like 'associated dossiers' do
      let(:subject) { create(:concept_with_dossiers, user: user) }
    end

    it_behaves_like 'associated facts' do
      let(:subject) { create(:concept_with_facts, facts_count: 3, world: world) }
      let(:path)    { world_concept_path(subject.world, subject) }
    end
  end

  context 'with image' do
    before(:example) do
      concept.image = fixture_file_upload(fixture_file_name('concept.jpg'))
      visit(world_concept_path(world, concept))
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.figure-image')
    end
  end

  context 'of another users world' do
    let(:other_concept) { other_world.concepts.last }

    before(:example) { visit world_concept_path(other_world, other_concept) }

    it 'redirects to worlds index' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
