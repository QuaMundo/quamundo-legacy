RSpec.describe 'Deleting a fact', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_facts, user: user) }
  let(:fact)  { world.facts.first }

  context 'of an own world' do
    before(:example)  { visit world_fact_path(world, fact) }

    it 'removes a fact', :js, :comprehensive do
      page.accept_confirm() do
        page.first('nav.context-menu a.nav-link[title="delete"]').click
      end
      expect(page).to have_current_path(world_facts_path(world))
      expect(page).to be_i18n_ready
      expect(Fact.find_by(id: fact.id)).to be_falsey
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_fact_path(world, fact) }
    end
  end

  context 'of another users world' do
    let(:other_world) { create(:world_with_facts) }
    let(:other_fact)  { other_world.facts.first }

    before(:example)  { visit world_fact_path(other_world, other_fact) }

    it 'refuses to remove fact of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
