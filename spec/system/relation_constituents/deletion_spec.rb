RSpec.describe 'Removing a relation constituent', type: :system do
  include_context 'Session'

  let(:const)     { create(:relation_constituent, user: user) }
  let(:relation)  { const.relation }
  let!(:relative) { create(:relation_constituent,
                           role: :relative, relation: relation) }
  let(:fact)      { relation.fact }
  let(:world)     { fact.world }
  let(:inventory) { const.fact_constituent.constituable }

  context 'from inventory view', :js, :comprehensive do
    it 'removes linkage to relation', db_triggers: true do
      visit(polymorphic_path([world, inventory]))
      page.find('div#relatives-header button').click
      page.accept_confirm do
        click_link(href: world_relation_constituent_path(world, relative),
                   title: 'destroy')
      end
      expect(page)
        .to have_current_path(world_fact_relation_path(world, fact, relation))
      relation.reload
      expect(relation.relation_constituents)
        .not_to include(relative)
    end
  end

  context 'from relation view' do
    it 'removes linkage to relation', :js, :comprehensive do
      # FIXME: Refactor and change layout of corresponding page
      visit(world_fact_relation_path(world, fact, relation))
      page.accept_confirm do
        click_link(href: world_relation_constituent_path(world, relative),
                  title: 'destroy')
      end
      expect(page)
        .to have_current_path(world_fact_relation_path(world, fact, relation))
      relation.reload
      expect(relation.relation_constituents)
        .not_to include(relative)
    end
  end
end
