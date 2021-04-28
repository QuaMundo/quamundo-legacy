# frozen_string_literal: true

RSpec.describe 'Deleting a relation', type: :system do
  include_context 'Session'

  context 'of own world' do
    let(:relation)  { create(:relation, user: user) }
    let(:world)     { relation.fact.world }

    before(:example)  do
      visit(
        world_fact_relation_path(world, relation.fact, relation)
      )
    end

    it 'removes a relation', :js, :comprehensive do
      page.find('.nav-item a.nav-link.dropdown').click
      page.accept_confirm do
        page.first('a.dropdown-item[title="delete"]').click
      end
      expect(page)
        .to have_current_path(world_fact_path(world, relation.fact))
      expect(Relation.find_by(id: relation.id)).to be_falsey
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_fact_relation_path(world, relation.fact, relation) }
    end
  end

  context 'of another users world' do
    let(:other_relation)  { create(:relation) }
    let(:other_world)     { other_relation.fact.world }

    it 'refuses to remove relation fo another users world' do
      visit(
        world_fact_relation_path(
          other_world, other_relation.fact, other_relation
        )
      )
      expect(page).to have_current_path(worlds_path)
    end
  end
end
