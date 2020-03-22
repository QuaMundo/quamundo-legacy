RSpec.describe 'locations/index', type: :view do
  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:location)    { create(:location, user: user) }
      let(:world)     { location.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render partial: 'locations/index_entry', locals: { index_entry: location }
      end

      it 'shows a location index entry' do
        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{location.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description',
                            text: /#{location.description}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{location.facts.count}/
        expect(rendered).to match /#{location.relatives.count}/

        expect(rendered)
          .to have_link(href: world_location_path(world, location))
        expect(rendered)
          .to have_link(href: edit_world_location_path(world, location))
        expect(rendered)
          .to have_link(href: world_location_path(world, location),
                        id: /delete-.+/)
      end
    end

    context 'not owning world' do
      let(:location)    { create(:location) }
      let(:world)     { location.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)
      end

      it 'does not show crud links with read permission only' do
        Permission.create(world: world, user: user, permissions: :r)

        render partial: 'locations/index_entry', locals: { index_entry: location }

        expect(rendered)
          .not_to have_link(href: edit_world_location_path(world, location))
        expect(rendered)
          .not_to have_link(href: world_location_path(world, location),
                            title: 'delete')
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'locations/index_entry', locals: { index_entry: location }

        expect(rendered)
          .to have_link(href: edit_world_location_path(world, location))
        expect(rendered)
          .to have_link(href: world_location_path(world, location),
                            title: 'delete')
      end
    end
  end

  context 'unregistered user not owning public readable world' do
    let(:location)    { create(:location) }
    let(:world)     { location.world }

    before(:example) do
      Permission.create(world: world, permissions: :public)

      # FIXME: `current_world` doesn't seem to be available, so work around ...
      controller.class.class_eval { include WorldAssociationController }
      allow(controller).to receive(:current_world).and_return(world)

      render partial: 'locations/index_entry', locals: { index_entry: location }
    end

    it 'does not render crud links' do
      expect(rendered)
        .not_to have_link(href: edit_world_location_path(world, location))
      expect(rendered)
        .not_to have_link(href: world_location_path(world, location),
                          title: 'delete')
    end
  end
end


