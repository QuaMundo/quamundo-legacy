# frozen_string_literal: true

RSpec.describe 'CRUD actions on notes', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }

  context 'create a note' do
    let(:note) { build(:note, noteable: world) }

    it_behaves_like 'valid_view' do
      let(:path) do
        new_polymorphic_path(
          [world, Note],
          note: {
            noteable_id: world.id,
            noteable_type: 'World'
          }
        )
      end
    end
  end

  context 'edit a note' do
    let(:note) { create(:note, noteable: world) }

    it_behaves_like 'valid_view' do
      let(:path) { edit_polymorphic_path([note]) }
    end
  end
end
