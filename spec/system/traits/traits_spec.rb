RSpec.describe 'CRUD actions on traits', type: :system do
  include_context 'Session'

  context 'edit traits' do
    let(:trait) { create(:world).trait }

    it_behaves_like('valid_view') do
      let(:path) { edit_trait_path(trait) }
    end
  end
end
