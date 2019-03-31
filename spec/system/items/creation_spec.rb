RSpec.describe 'Creating an item', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }

  context 'in own world' do
    before(:example) { visit new_world_item_path(world) }

    it 'is successful with completed form' do
      item_count = world.items.count
      fill_in('Name', with: 'A new item')
      fill_in('Description', with: 'A new items description')
      page.attach_file('item_image', fixture_file_name('item.png'))
      click_button('submit')
      expect(world.items.count).to be > item_count
      expect(page).to have_selector('.alert-info',
                                    text: 'Item A new item successfully')
      expect(current_path)
        .to eq(world_item_path(world, Item.find_by(name: 'A new item')))
    end

    it 'redirects to new form if name is missing' do
      click_button('submit')
      expect(page).to have_css('.alert', text: 'Name')
    end

    it_behaves_like 'valid_view' do
      let(:subject) { new_world_item_path(world) }
    end
  end

  context 'in other users world' do
    let(:other_world) { other_user_with_worlds.worlds.first }

    before(:example) { visit new_world_item_path(other_world) }

    it 'redirects to worlds index' do
      expect(current_path).to eq(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                    text: 'You are not allowed')
    end
  end
end
