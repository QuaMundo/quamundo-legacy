# frozen_string_literal: true

RSpec.describe 'Showing a relation', type: :system do
  include_context 'Session'

  context 'in own world' do
    context 'unidirectional' do
      let(:relation)  { create(:relation_with_constituents, user: user) }
      let(:fact)      { relation.fact }
      let(:world)     { fact.world }

      it 'shows details of the relation including constituents' do
        visit(world_fact_relation_path(world, fact, relation))
        expect(page).to have_content(relation.description)
        # subjects
        page.within('#subjects') do
          expect(page).to have_content(relation.name)
          relation.subjects.each do |subject|
            expect(page)
              .to have_content(subject.fact_constituent.constituable.name)
            expect(page)
              .to have_link(
                href: polymorphic_path(
                  [relation.fact.world, subject.fact_constituent.constituable]
                )
              )
          end
        end
        # relatives
        page.within('#relatives') do
          # FIXME: Ensure there's no reverse_name
          expect(page).not_to have_selector('h3+h4')
          relation.relatives.each do |relative|
            expect(page)
              .to have_content(relative.fact_constituent.constituable.name)
            expect(page)
              .to have_link(
                href: polymorphic_path(
                  [relation.fact.world, relative.fact_constituent.constituable]
                )
              )
          end
        end
      end

      it_behaves_like 'valid_view' do
        let(:subject) { world_fact_relation_path(world, relation.fact, relation) }
      end
    end

    context 'bidirectional' do
      let(:relation) do
        create(:relation_with_constituents,
               user: user,
               bidirectional: true)
      end
      let(:fact)      { relation.fact }
      let(:world)     { fact.world }

      it 'also shows reverse name of relation' do
        visit(world_fact_relation_path(world, fact, relation))
        page.within('#relatives') do
          expect(page).to have_selector('h4', text: relation.reverse_name)
        end
      end
    end
  end

  context 'in another users world' do
    let(:other_relation) { create(:relation) }

    it 'redirects to world index' do
      visit(world_fact_relation_path(
              other_relation.fact.world, other_relation.fact, other_relation
            ))
      expect(page).to have_current_path(worlds_path)
    end
  end
end
