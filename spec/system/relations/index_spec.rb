# frozen_string_literal: true

RSpec.describe 'Listing relations', type: :system do
  include_context 'Session'

  let(:fact)    { create(:fact, user: user) }
  let(:world)   { fact.world }

  before(:example) do
    3.times { create(:relation, fact: fact) }
    visit world_fact_relations_path(world, fact)
  end

  context 'of an own world' do
    it 'shows a list af a facts relations' do
      fact.relations.each do |relation|
        expect(page)
          .to have_selector("[id=\"index-entry-relation-#{relation.id}\"]")
      end
    end

    it 'shows index context menu' do
      expect(page).to have_link(href: world_path(world))
      expect(page).to have_link(href: world_fact_path(world, fact))
      expect(page).to have_link(href: new_world_fact_relation_path(world, fact))
    end
  end

  context 'of another users world' do
    let(:other_world) { create(:world) }
    let(:other_fact)  { create(:fact, world: other_world) }
    let!(:relation) { create(:relation, fact: other_fact) }

    it 'does not show relations of another users world' do
      visit world_fact_relations_path(other_world, other_fact)
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('.alert.alert-danger')
    end
  end
end
