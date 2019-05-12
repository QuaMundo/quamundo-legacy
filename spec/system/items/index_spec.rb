RSpec.describe 'Listing items', type: :system, login: :user_with_worlds do
  include_context 'Session'

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

    it 'shows index context menu' do
      page.first('.card-header') do
        expect(page).to have_link(href: world_path(world))
        expect(page).to have_link(href: new_world_item_path(world))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_items_path(world) }
    end
  end

  context 'of another users world' do
    before(:example) { visit world_items_path(other_world) }

    it 'does not show items of another users world' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
