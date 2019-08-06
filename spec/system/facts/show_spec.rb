RSpec.describe 'Showing a fact', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_facts, user: user) }
  let(:fact)  { world.facts.first }

  context 'of an own world' do
    before(:example) { visit world_fact_path(world, fact) }

    it 'shows fact details' do
      expect(page).to have_content(fact.name)
      expect(page).to have_content(fact.description)
      expect(page)
        .to have_link(fact.world.name, href: world_path(world))
      expect(page).to have_selector('li[id^="fact_constituent"]',
                                    count: fact.fact_constituents.count)
      expect(page)
        .to have_link(href: new_world_fact_fact_constituent_path(world, fact))
      fact.fact_constituents.each do |fc|
        expect(page).to have_content(fc.constituable.name)
        expect(page)
          .to have_link(href: polymorphic_path([world, fc.constituable]))
        expect(page).to have_link(
          href: edit_world_fact_fact_constituent_path(world, fact, fc)
        )
        expect(page).to have_link(
          href: world_fact_fact_constituent_path(world, fact, fc),
          title: 'destroy'
        )
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
