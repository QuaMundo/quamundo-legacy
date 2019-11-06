RSpec.describe 'Adding a relation constituent', type: :system do
  include_context 'Session'

  context 'with available candidates' do
    let(:fact)        { create(:fact_with_constituents, user: user) }
    let(:constituent) { fact.fact_constituents.first }
    let(:world)       { fact.world }
    let(:relation)    { create(:relation, fact: fact) }

    it 'raises an error if relation param is missing' do
      visit new_world_relation_constituent_path(world)
      expect(page).to have_current_path(world_path(world))
      expect(page).to have_selector('.alert.alert-danger')
    end

    it 'raises an error if no consituent is choosen', db_triggers: true do
      visit new_world_relation_constituent_path(
        world,
        relation_constituent: { relation_id: relation.id })
      click_button('submit')
      # expect(page).to have_current_path(world_path(world))
      expect(page).to have_selector('.alert.alert-danger')
    end

    it 'can add a subject to a relation', db_triggers: true do
      visit new_world_relation_constituent_path(
        world,
        relation_constituent: { relation_id: relation.id })
      choose('relation_constituent_role_subject')
      select(constituent.constituable.name,
             from: 'relation_constituent_fact_constituent_id')
      click_button('submit')
      relation.reload
      expect(relation.subjects.map(&:fact_constituent)).to include(constituent)
      expect(page)
        .to have_current_path(world_fact_relation_path(world, fact, relation))
    end

    it 'can add a relative to a relation', db_triggers: true do
      visit new_world_relation_constituent_path(
        world,
        relation_constituent: { relation_id: relation.id })
      choose('relation_constituent_role_relative')
      select(constituent.constituable.name,
             from: 'relation_constituent_fact_constituent_id')
      click_button('submit')
      relation.reload
      expect(relation.relatives.map(&:fact_constituent)).to include(constituent)
    end

    it 'provides only unrelated constituents for choosing', db_triggers: true do
      other_relation = create(:relation_with_constituents,
                              user: user,
                              subjects_count: 1,
                              relatives_count: 1)
      rc = relation.relation_constituents.create(fact_constituent: constituent,
                                                 role: :subject)
      visit(new_world_relation_constituent_path(
        world,
        relation_constituent: { relation_id: relation.id }))
      page.within('select#relation_constituent_fact_constituent_id') do
        fact.fact_constituents.where(['id != ?', constituent.id]).each do |c|
          expect(page).to have_selector("option[value=\"#{c.id}\"]")
        end

        expect(page)
          .not_to have_selector("option[value=\"#{constituent.id}\"]")
        other_subject = other_relation.subjects.first.fact_constituent
        other_relative = other_relation.relatives.first.fact_constituent
        expect(page)
          .not_to have_selector("option[value=\"#{other_subject}\"]")
        expect(page)
          .not_to have_selector("option[value=\"#{other_relative}\"]")
      end
    end
  end

  context 'without available candidates' do
    let(:fact)        { create(:fact, user: user) }
    let(:relation)    { create(:relation, fact: fact) }
    let(:world)       { fact.world }

    it 'redirects to relation show view if no candidates left' do
      visit(new_world_relation_constituent_path(
        world,
        relation_constituent: { relation_id: relation.id }))
      expect(page).to have_current_path(
        world_fact_relation_path(world, fact, relation))
      expect(page).to have_selector('.alert.alert-info')
    end
  end
end
