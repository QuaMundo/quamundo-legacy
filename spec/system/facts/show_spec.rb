# frozen_string_literal: true

RSpec.describe 'Showing a fact', type: :system do
  include_context 'Session'

  let(:fact)  { create(:fact_with_constituents, user: user) }
  let(:world) { fact.world }

  context 'of an own world' do
    it 'shows fact details' do
      visit world_fact_path(world, fact)
      expect(page).to have_content(fact.name)
      expect(page).to have_content(fact.description)
      expect(page)
        .to have_link(fact.world.name, href: world_path(world))
      expect(page).to have_selector('li[id^="index-entry-fact_constituent"]',
                                    count: fact.fact_constituents.count)
      expect(fact.fact_constituents.count).to be > 0
      fact.fact_constituents.each do |fc|
        page.within("##{element_id(fc, 'index-entry')}") do
          expect(page).to have_content(fc.constituable.name)
          # CRUD links are tested in
          # spec/views/fact_constituent_index_element_spec.rb
        end
      end
    end

    context 'with relations' do
      let!(:relation1)  { create(:relation, fact: fact, name: 'rel 1') }
      let!(:relation2)  { create(:relation, fact: fact, name: 'rel 2') }

      it 'shows a list of relations' do
        visit(world_fact_path(world, fact))
        expect(page).to have_selector('#relations')
        [relation1, relation2].each do |relation|
          expect(page).to have_content(relation.name)
          expect(page).to have_content(relation.description)
          expect(page)
            .to have_link(href: world_fact_relation_path(world, fact, relation))
          expect(page)
            .to have_link(href: world_fact_relation_path(world, fact, relation),
                          id: /delete-.*/)
          expect(page)
            .to have_link(href: edit_world_fact_relation_path(
              world, fact, relation
            ))
        end
      end
    end

    context 'with image' do
      before(:example) do
        fact.image = fixture_file_upload(fixture_file_name('fact.jpg'))
        fact.save
        visit(world_fact_path(world, fact))
      end

      it 'has an img tag' do
        expect(page).to have_selector('img.fact-image')
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_fact_path(world, fact) }
    end

    it_behaves_like 'associated note' do
      let(:subject) { create(:fact_with_notes, world: world) }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { fact }
    end

    it_behaves_like 'associated traits' do
      let(:subject) { create(:fact_with_traits, world: world) }
    end

    it_behaves_like 'associated dossiers' do
      let(:subject) { create(:fact_with_dossiers, user: user) }
    end
  end

  context 'of another users world' do
    let(:other_world) { create(:world_with_facts) }
    let(:other_fact)  { other_world.facts.first }

    before(:example) { visit world_fact_path(other_world, other_fact) }

    it 'redirects to world index' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
