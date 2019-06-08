RSpec.describe 'Creating an item', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_items, user: user) }
  let(:other_world) { create(:world_with_items) }

  context 'in own world' do
    before(:example) { visit new_world_item_path(world) }

    it 'is successful with completed form' do
      item_count = world.items.count
      fill_in('Name', with: 'A new item')
      fill_in('Description', with: 'A new items description')
      page.attach_file('item_image', fixture_file_name('item.jpg'))
      click_button('submit')
      expect(world.items.count).to be > item_count
      expect(page).to have_selector('.alert-info',
                                    text: /successfully\s+created/i)
      expect(page)
        .to have_current_path(world_item_path(world, Item.find_by(name: 'A new item')))
    end

    it 'redirects to new form if name is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: /could not be created/i)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { new_world_item_path(world) }
    end
  end

  context 'in other users world' do
    before(:example) { visit new_world_item_path(other_world) }

    it 'redirects to worlds index' do
      expect(page).to have_current_path(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                    text: /not allowed/i)
    end
  end
end
