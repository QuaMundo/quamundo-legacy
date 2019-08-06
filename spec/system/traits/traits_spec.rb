RSpec.describe 'CRUD actions on traits', type: :system do
  include_context 'Session'

  # FIXME: Refactor - item creation redundant
  context 'edit traits' do
    let(:trait) { create(:world).trait }

    it 'can add a trait', :js do
      item = create(:item_with_traits, world: build(:world, user: user))
      item.save
      visit edit_trait_path(item.trait)
      fill_in('New Key', with: 'a_new_key')
      fill_in('New Value', with: 'a_new_value')
      page.find('#add-trait').click
      expect(page).to have_selector('label', text: 'a_new_key')
      expect(page).to have_selector('input[value="a_new_value"]')
      fill_in('New Key', with: 'another_new_key')
      fill_in('New Value', with: 'another_new_value')
      click_button('submit')
      expect(page).to have_current_path(world_item_path(item.world, item))
      page.find('button[aria-controls="traits-collection"]').click
      expect(page).to have_selector('th', text: 'a_new_key')
      expect(page).to have_selector('th', text: 'another_new_key')
      expect(page).to have_selector('td', text: 'a_new_value')
      expect(page).to have_selector('td', text: 'another_new_value')
    end

    it 'can remove traits', :js do
      item = create(:item, world: build(:world, user: user))
      item.trait.attributeset = { a_key: 'a_value' }
      item.trait.save
      visit edit_trait_path(item.trait)
      expect(page).to have_selector('label', text: 'a_key')
      page.find('button.remove-trait').click
      expect(page).not_to have_selector('label', text: 'a_key')
      click_button('submit')
      expect(page).to have_current_path(world_item_path(item.world, item))
      expect(page).not_to have_selector('th', text: 'a_key')
      expect(page).not_to have_selector('td', text: 'a_value')
    end

    it 'has translated confirm dialog' do
      item = create(:item_with_traits)
      visit world_item_path(item.world, item)
    end


    it_behaves_like('valid_view') do
      let(:path) { edit_trait_path(trait) }
    end
  end
end
