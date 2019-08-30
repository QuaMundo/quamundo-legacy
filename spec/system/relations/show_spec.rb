RSpec.describe 'Showing a relation', type: :system do
  include_context 'Session'

  let(:relation)  { create(:relation, user: user) }
  let(:fact)      { relation.fact }
  let(:world)     { fact.world }

  context 'in own world' do
    context 'unidirectional' do
      it 'shows details of the relation including constituents' do
        visit(world_fact_relation_path(world, fact, relation))
        expect(page).to have_content(relation.name)
        expect(page).to have_content(relation.description)
        # subjects
        page.within('#subjects') do
          relation.subjects.each do |subject|
            expect(page)
              .to have_content(subject.fact_constituent.constituable.name)
            expect(page)
              .to have_link(
                href: polymorphic_path(
                  [relation.fact.world, subject.fact_constituent.constituable]
                )
            )
            expect(page)
              .to have_link(
                href: world_relation_constituent_path(fact.world, subject),
                title: 'destroy'
            )
            expect(page)
              .to have_link(
                href: edit_world_relation_constituent_path(
                  fact.world, subject,
                  relation_constituent: { relation_id: relation.id }
                )
            )
          end
        end
      end

      it 'has a link to add relation constituents' do
        visit(world_fact_relation_path(world, fact, relation))
        expect(page).to have_link(
          href: new_world_relation_constituent_path(
            world, relation_constituent: { relation_id: relation.id }
          ))
      end
    end

    context 'bidirectional'

    it_behaves_like 'valid_view' do
      let(:subject) { world_fact_relation_path(world, relation.fact, relation) }
    end
  end

  context 'in another users world' do
    let(:other_relation)  { create(:relation) }

    it 'redirects to world index' do
      visit(world_fact_relation_path(
        other_relation.fact.world, other_relation.fact, other_relation))
      expect(page).to have_current_path(worlds_path)
    end
  end
end
