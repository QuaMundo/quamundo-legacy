# frozen_string_literal: true

RSpec.describe 'Updating/Editing an item', type: :system do
  include_context 'Session'

  let(:item)          { create(:item, user: user) }
  let(:world)         { item.world }
  let(:other_item)    { create(:item) }
  let(:other_world)   { other_item.world }

  context 'of own world' do
    it 'can update name and description' do
      QuamundoTestHelpers.attach_file(
        item.image, fixture_file_name('item.jpg')
      )
      visit edit_world_item_path(world, item)
      expect(page).to have_selector("img##{element_id(item, 'img')}")
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
      visit edit_world_item_path(world, item)
      page.attach_file('item_image', fixture_file_name('item.jpg'))
      click_button('submit')
      expect(page).to have_current_path(world_item_path(world, item))
      expect(item.reload.image).to be_attached
      expect(page).to have_selector('img.item-image')
    end

    it 'refuses to attach non image files', :comprehensive do
      visit edit_world_item_path(world, item)
      page.attach_file('item_image', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to have_current_path(world_item_path(world, item))
      expect(item.image).not_to be_attached
      expect(page).to have_selector('.alert', text: /^Failed to update/)
    end

    it_behaves_like 'valid_view' do
      let(:subject) { edit_world_item_path(world, item) }
    end

    it_behaves_like 'editable tags' do
      let(:path)    { edit_world_item_path(world, item) }
    end

    it_behaves_like 'editable traits' do
      let(:subject) { create(:item, :with_traits, user: user) }
    end
  end

  context 'of another users world' do
    it 'refuse other users worlds item' do
      visit edit_world_item_path(other_world, other_item)
      expect(page).to have_current_path(worlds_path)
    end
  end
end
