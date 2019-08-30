RSpec.describe 'Deleting an item', type: :system do
  include_context 'Session'

  let(:item)        { create(:item, user: user) }
  let(:world)       { item.world }
  let(:other_item)  { create(:item) }
  let(:other_world) { other_item.world }

  context 'of an own world' do
    before(:example) { visit world_item_path(world, item) }

    it 'removes this item', :js, :comprehensive do
      page.find('.nav-item a.nav-link.dropdown').click
      page.accept_confirm() do
        page.first('a.dropdown-item[title="delete"]').click
      end
      expect(page).to have_current_path(world_items_path(world))
      expect(Item.find_by(id: item.id)).to be_falsey
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_item_path(world, item) }
    end
  end

  context 'of another users world' do
    before(:example) { visit world_item_path(other_world, other_item) }

    it 'refuses to remove item of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
