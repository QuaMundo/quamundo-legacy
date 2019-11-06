RSpec.describe 'relation_constituents/index', type: :view do
  include_context 'Session'
  let(:relation)      { create(:relation_with_constituents,
                               subjects_count: 1,
                               relatives_count: 1,
                               bidirectional: true) }
  let(:fact)          { relation.fact }
  let(:world)         { fact.world }

  context 'one direction (of relation)' do
    let(:index_entry)   { relation.subject_relative_relations.first }
    let(:subject)       { index_entry.subject.fact_constituent.constituable }
    let(:relative)      { index_entry.relative.fact_constituent.constituable }

    it 'shows a relation constituent index entry', db_triggers: true do
      render(partial: 'relation_constituents/index_entry',
             locals: { index_entry: index_entry })

      expect(rendered).to have_selector('li.index_entry')
      expect(rendered).to have_selector(
        '.index_entry_name',
        text: /#{subject.name}\s+#{index_entry.name}\s+#{relative.name}/)
      expect(rendered).to have_selector('.index_entry_description',
                                        text: relation.description)
      expect(rendered).to match /#{fact.name}/

      expect(rendered)
        .to have_link(href: world_fact_relation_path(world, fact, relation))
      expect(rendered)
        .to have_link(href: edit_world_fact_relation_path(world, fact, relation))
      expect(rendered)
        .to have_link(
          href: world_relation_constituent_path(world, index_entry.relative),
          id: /delete-.+/
      )
    end
  end

  context 'other direction (of relation)' do
    let(:index_entry)   { relation.subject_relative_relations.second }
    let(:subject)       { index_entry.subject.fact_constituent.constituable }
    let(:relative)      { index_entry.relative.fact_constituent.constituable }

    it 'shows a relation constituent index entry', db_triggers: true do
      render(partial: 'relation_constituents/index_entry',
             locals: { index_entry: index_entry })

      expect(rendered).to have_selector('li.index_entry')
      expect(rendered).to have_selector(
        '.index_entry_name',
        text: /#{subject.name}\s+#{index_entry.name}\s+#{relative.name}/)
      expect(rendered).to have_selector('.index_entry_description',
                                        text: relation.description)
      expect(rendered).to match /#{fact.name}/

      expect(rendered)
        .to have_link(href: world_fact_relation_path(world, fact, relation))
      expect(rendered)
        .to have_link(href: edit_world_fact_relation_path(world, fact, relation))
      expect(rendered)
        .to have_link(
          href: world_relation_constituent_path(world, index_entry.relative),
          id: /delete-.+/
      )
    end
  end
end
