RSpec.describe 'CRUD actions on tags', type: :system do
  # FIXME: Refactor `Session`
  include_context 'Session'

  let(:tag) { create(:world_with_tags).tag }

  before(:example) { tag.save }

  context 'edit a tag' do
    it_behaves_like 'valid_view' do
      let(:path) { edit_tag_path(tag) }
    end
  end
end
