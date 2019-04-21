RSpec.describe 'Showing an item', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }
  let(:item) { world.items.first }

  context 'of an own world' do
    before(:example) { visit world_item_path(world, item) }

    it 'shows item details' do
      expect(page).to have_content(item.name)
      expect(page).to have_content(item.description)
      expect(page)
        .to have_link(item.world.title, href: world_path(world))
    end

    it 'shows item menu', :comprehensive do
      page.first('nav.nav') do
        expect(page).to have_link(href: new_world_item_path(world))
        expect(page).to have_link(href: world_items_path(world))
        expect(page).to have_link(href: edit_world_item_path(world, item))
        expect(page).to have_link('delete',
                                  href: world_item_path(world, item))
      end
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_item_path(world, item) }
    end
  end

  context 'with image' do
    before(:example) do
      item.image = fixture_file_upload(fixture_file_name('item.png'))
      visit(world_item_path(world, item))
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.figure-image')
    end
  end

  context 'of another users world' do
    let(:other_world) { other_user_with_worlds.worlds.first }
    let(:other_item) { other_world.items.last }

    before(:example) { visit world_item_path(other_world, other_item) }

    it 'redirects to worlds index' do
      expect(current_path).to eq(worlds_path)
    end
  end
end
