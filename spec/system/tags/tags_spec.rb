RSpec.describe 'CRUD actions on tags', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:tag) { world.tag }

  context 'edit a tag' do
    it_behaves_like 'valid_view' do
      let(:path) { edit_polymorphic_path(tag) }
    end
  end
end
