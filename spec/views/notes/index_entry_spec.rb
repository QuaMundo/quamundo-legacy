RSpec.describe 'notes/index', type: :view do
  let(:world)     { create(:world_with_notes, notes_count: 1) }
  let(:note)      { world.notes.first }

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:world) { create(:world_with_notes, user: user, notes_count: 1) }


      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render partial: 'notes/index_entry', locals: { index_entry: note }
      end

      it 'shows a note index entry' do
        expect(rendered).to have_selector('div.note')
        expect(rendered)
          .to have_selector('p', text: /#{note.content}/)

        expect(rendered)
          .to have_link(href: edit_note_path(note))
        expect(rendered)
          .to have_link(href: note_path(note),
                        id: /delete-.+/)
      end
    end

    context 'not owning world' do
      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)
      end

      it 'does not show crud links with read permission only' do
        Permission.create(world: world, user: user, permissions: :r)

        render partial: 'notes/index_entry', locals: { index_entry: note }

        expect(rendered)
          .not_to have_link(href: edit_note_path(note))
        expect(rendered)
          .not_to have_link(href: note_path(note),
                            title: 'delete')
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'notes/index_entry', locals: { index_entry: note }

        expect(rendered)
          .to have_link(href: edit_note_path(note))
        expect(rendered)
          .to have_link(href: note_path(note),
                            title: 'delete')
      end
    end
  end

  context 'unregistered user not owning public readable world' do
    before(:example) do
      Permission.create(world: world, permissions: :public)

      # FIXME: `current_world` doesn't seem to be available, so work around ...
      controller.class.class_eval { include WorldAssociationController }
      allow(controller).to receive(:current_world).and_return(world)

      render partial: 'notes/index_entry', locals: { index_entry: note }
    end

    it 'does not render crud links' do
      expect(rendered)
        .not_to have_link(href: edit_note_path(note))
      expect(rendered)
        .not_to have_link(href: note_path(note),
                          title: 'delete')
    end
  end
end


