RSpec.describe 'Updating/Editing an item',
  type: :system, login: :user_with_worlds do

  include_context 'Session'

  let(:item) { world.items.first }
  let(:other_item) { other_world.items.first }

  context 'of own world' do
    before(:example) { visit edit_world_item_path(world, item) }

    it 'can update name and description' do
      fill_in('Name', with: 'New Name')
      fill_in('Description', with: 'New Description')
      click_button('submit')
      item.reload
      expect(page).to have_current_path(world_item_path(world, item))
      expect(item.name).to eq('New Name')
      expect(item.description).to eq('New Description')
      expect(page).to have_content('New Name')
      expect(page).to have_content('New Description')
    end

    it 'attaches an image', :comprehensive do
      page.attach_file('item_image', fixture_file_name('item.jpg'))
      click_button('submit')
      expect(page).to have_current_path(world_item_path(world, item))
      expect(item.image).to be_attached
      expect(page).to have_selector('img.figure-image')
    end

    it 'refuses to attach non image files', :comprehensive do
      page.attach_file('item_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to have_current_path(world_item_path(world, item))
      expect(item.image).not_to be_attached
      pending("Show view not yet implemented")
      expect(page).to have_selector('.alert', text: 'Only images may be')
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_item_path(world, item) }
    end
  end

  context 'of another users world' do
    before(:example) { visit edit_world_item_path(other_world, other_item) }

    it 'refuse other users worlds item' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
