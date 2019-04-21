RSpec.describe 'Deleting an item', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.last }
  let(:other_world) { other_user_with_worlds.worlds.last }
  let(:item) { world.items.first }
  let(:other_item) { other_world.items.first }

  context 'of an own world' do
    before(:example) { visit world_item_path(world, item) }

    it 'removes this item', :js, :comprehensive do
      page.accept_confirm() do
        page.first('nav.context-menu a.nav-link[title="delete"]').click
      end
      expect(current_path).to eq(world_items_path(world))
      expect(Item.find_by(id: item.id)).to be_falsey
    end
  end

  context 'of another users world' do
    before(:example) { visit world_item_path(other_world, other_item) }

    it 'refuses to remove item of another users world' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
