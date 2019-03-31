RSpec.describe 'Listing items', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }
  let(:other_world) { other_user_with_worlds.worlds.first }

  context 'of an own world' do
    before(:example) { visit world_items_path(world) }

    it 'shows cards of each item' do
      world.items.each do |item|
        page
          .within("div[id=\"card-item-#{item.id}\"]") do
          expect(page).to have_content(item.name)
          expect(page).to have_content(item.description)
          expect(page).to have_link(href: world_item_path(world, item))
          expect(page).to have_selector(".card-img")
        end
      end
    end
  end

  context 'of another users world' do
    before(:example) { visit world_items_path(other_world) }

    it 'does not show items of another users world' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
