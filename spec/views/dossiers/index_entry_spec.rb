RSpec.describe 'dossiers/index', type: :view do
  let(:world)     { create(:world_with_dossiers, dossiers_count: 1) }
  let(:dossier)   { world.dossiers.first }

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:world) {
        create(:world_with_dossiers, user: user, dossiers_count: 1)
      }


      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render partial: 'dossiers/index_entry', locals: { index_entry: dossier }
      end

      it 'shows a dossier index entry' do
        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{dossier.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description',
                            text: /#{dossier.description}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{dossier.images.count}/
        expect(rendered).to match /#{dossier.audios.count}/
        expect(rendered).to match /#{dossier.videos.count}/
        expect(rendered).to match /#{dossier.files.count}/

        expect(rendered)
          .to have_link(href: dossier_path(dossier))
        expect(rendered)
          .to have_link(href: edit_dossier_path(dossier))
        expect(rendered)
          .to have_link(href: dossier_path(dossier),
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

        render partial: 'dossiers/index_entry', locals: { index_entry: dossier }

        expect(rendered)
          .not_to have_link(href: edit_dossier_path(dossier))
        expect(rendered)
          .not_to have_link(href: dossier_path(dossier),
                            title: 'delete')
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'dossiers/index_entry', locals: { index_entry: dossier }

        expect(rendered)
          .to have_link(href: edit_dossier_path(dossier))
        expect(rendered)
          .to have_link(href: dossier_path(dossier),
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

      render partial: 'dossiers/index_entry', locals: { index_entry: dossier }
    end

    it 'does not render crud links' do
      expect(rendered)
        .not_to have_link(href: edit_dossier_path(dossier))
      expect(rendered)
        .not_to have_link(href: dossier_path(dossier),
                          title: 'delete')
    end
  end
end

