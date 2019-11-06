RSpec.describe 'Creating a relation', type: :system do
  include_context 'Session'

  let(:subject)     { create(:fact_constituent, user: user) }
  let(:fact)        { subject.fact }
  let(:world)       { fact.world }
  let(:relative)    { create(:fact_constituent, fact: fact) }
  
  before(:example)  { visit new_world_fact_relation_path(world, fact) }

  context 'in own world' do
    context 'unidirectional' do
      it 'is successfully with completed form' do
        fill_in('Name', with: 'name of relation')
        fill_in('Description', with: 'Description of relates to')
        click_button('submit')
        expect(page).to have_current_path(
          world_fact_relation_path(world, fact, fact.relations.first)
        )
        expect(page).to have_content('name of relation')
        expect(page).to have_content('unidirectional')
        expect(page).to have_content('Description of relates to')
      end

      it 'refuses creation without a name' do
        click_button('submit')
        expect(page).to have_selector('.alert.alert-danger')
      end
    end

    context 'bidirectional' do
      it 'is successfully with completed form' do
        fill_in('Name', with: 'name of relation')
        fill_in('Reverse name', with: 'reverse name of relation')
        fill_in('Description', with: 'Description of relates to')
        click_button('submit')
        expect(page).to have_current_path(
          world_fact_relation_path(world, fact, fact.relations.first)
        )
        expect(page).to have_content('name of relation')
        expect(page).to have_content('bidirectional')
        expect(page).to have_content('Description of relates to')
      end
    end
  end

  context 'in another users world' do
    let(:other_world) { create(:world) }
    let(:fact)        { create(:fact, world: other_world) }

    it 'redirects to world index' do
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('.alert.alert-danger', text: /not allowed/)
    end
  end
end
