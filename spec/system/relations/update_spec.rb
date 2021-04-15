# frozen_string_literal: true

RSpec.describe 'Updating/Editing a relation', type: :system do
  include_context 'Session'

  let(:relation)  do
    create(:relation,
           name: 'relation',
           reverse_name: 'reverse relation',
           user: user)
  end
  let(:world)     { relation.fact.world }

  context 'of own world' do
    before(:example) do
      visit(
        edit_world_fact_relation_path(world, relation.fact, relation)
      )
    end

    it 'can change name, reverse_name and description' do
      fill_in('Name', with: 'new relation name')
      fill_in('Reverse name', with: 'new reverse relation name')
      fill_in('Description', with: 'New description')
      click_button('submit')
      expect(page).to have_current_path(
        world_fact_relation_path(world, relation.fact, relation)
      )
      expect(page).to have_content('new relation name')
      # FIXME: Actually reverse name is not shown in view
      # expect(page).to have_content('new reverse relation name')
      expect(page).to have_content('New description')
    end

    it 'can make a bidirectional relation unidirectional' do
      fill_in('Reverse name', with: '')
      click_button('submit')
      expect(page).to have_content('unidirectional')
    end

    it 'refuses to update relation with empty name' do
      fill_in('Name', with: '')
      click_button('submit')
      expect(page).to have_selector('.alert.alert-danger')
    end

    it_behaves_like 'valid_view' do
      let(:subject) do
        edit_world_fact_relation_path(
          world, relation.fact, relation
        )
      end
    end
  end

  context 'of another users world' do
    let(:other_relation)  { create(:relation) }
    let(:other_world)     { other_relation.fact.world }

    it 'redirects to worlds index' do
      visit edit_world_fact_relation_path(
        other_world, other_world.facts.first, other_relation
      )
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('.alert.alert-danger')
    end
  end
end
