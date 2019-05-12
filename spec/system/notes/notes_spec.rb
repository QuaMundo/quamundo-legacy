RSpec.describe 'CRUD actions on notes', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:note) { world.notes.first }

  context 'create a note' do
    it_behaves_like 'valid_view' do
      let(:path) { new_polymorphic_path([world, Note]) }
    end
  end

  context 'edit a note' do
    it_behaves_like 'valid_view' do
      let(:path) { edit_polymorphic_path([note]) }
    end
  end
end
