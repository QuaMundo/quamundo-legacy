RSpec.describe 'CRUD actions on traits', type: :system do
  include_context 'Session'

  context 'edit traits' do
    let(:trait) { create(:world).trait }

    it 'has translated confirm dialog' do
      item = create(:item_with_traits)
      visit world_item_path(item.world, item)
      expect(page).to have_i18n_ready_dialogs('a[id^="delete-trait-"]')
    end


    it_behaves_like('valid_view') do
      let(:path) { edit_trait_path(trait) }
    end
  end
end
