RSpec.describe 'CRUD actions on notes', type: :system do
  include_context 'Session'

  let(:world) { create(:world) }

  context 'create a note' do
    let(:note) { build(:note, noteable: world) }

    it_behaves_like 'valid_view' do
      let(:path) { new_polymorphic_path([world, Note]) }
    end
  end

  context 'edit a note' do
    let(:note) { create(:note, noteable: world) }

    it_behaves_like 'valid_view' do
      let(:path) { edit_polymorphic_path([note]) }
    end
  end
end
