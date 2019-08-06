RSpec.describe 'Showing an item', type: :system do
  include_context 'Session'

  let(:world) { create(:world_with_items, user: user) }
  let(:other_world) { create(:world_with_items) }
  let(:item) { world.items.first }

  context 'of an own world' do
    before(:example) { visit world_item_path(world, item) }

    it 'shows item details' do
      expect(page).to have_content(item.name)
      expect(page).to have_content(item.description)
      expect(page)
        .to have_link(item.world.name, href: world_path(world))
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

    it_behaves_like 'associated note' do
      let(:subject) { create(:item_with_notes, world: world) }
    end

    it_behaves_like 'associated tags' do
      let(:subject) { item }
    end

    it_behaves_like 'associated traits' do
      let(:subject) { create(:item_with_traits, world: world) }
    end

    it_behaves_like 'associated dossiers' do
      let(:subject) { create(:item_with_dossiers, user: user) }
    end

    it_behaves_like 'associated facts' do
      let(:subject) { create(:item_with_facts, facts_count: 3, world: world) }
      let(:path)    { world_item_path(subject.world, subject) }
    end
  end

  context 'with image' do
    before(:example) do
      item.image = fixture_file_upload(fixture_file_name('item.jpg'))
      visit(world_item_path(world, item))
    end

    it 'has an img tag' do
      expect(page).to have_selector('img.item-image')
    end
  end

  context 'of another users world' do
    let(:other_item) { other_world.items.last }

    before(:example) { visit world_item_path(other_world, other_item) }

    it 'redirects to worlds index' do
      expect(page).to have_current_path(worlds_path)
    end
  end
end
