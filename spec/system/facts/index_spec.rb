RSpec.describe 'Listint facts', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_facts, user: user) }

  context 'of an own world' do
    before(:example) { visit world_facts_path(world) }

    it 'shows a list of facts' do
      world.facts.each do |fact|
        expect(page).to have_content(fact.name)
        expect(page).to have_content(fact.description)
        expect(page).to have_link(href: world_fact_path(world, fact))
      end
    end

    it 'shows index context menu' do
      expect(page).to have_link(href: world_path(world))
      expect(page).to have_link(href: new_world_fact_path(world))
    end
  end

  context 'of another users world' do
    let(:other_world) { create(:world) }
    before(:example) { visit world_facts_path(other_world) }

    it 'does not show facts of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
