RSpec.describe 'facts/index', type: :view do
  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:fact)    { create(:fact, user: user) }
      let(:world)     { fact.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render partial: 'facts/index_entry', locals: { index_entry: fact }
      end

      it 'shows a fact index entry' do
        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{fact.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description',
                            text: /#{fact.description}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{fact.concepts.count}/
        expect(rendered).to match /#{fact.figures.count}/
        expect(rendered).to match /#{fact.items.count}/
        expect(rendered).to match /#{fact.locations.count}/

        expect(rendered)
          .to have_link(href: world_fact_path(world, fact))
        expect(rendered)
          .to have_link(href: edit_world_fact_path(world, fact))
        expect(rendered)
          .to have_link(href: world_fact_path(world, fact),
                        id: /delete-.+/)
      end
    end

    context 'not owning world' do
      let(:fact)    { create(:fact) }
      let(:world)     { fact.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)
      end

      it 'does not show crud links with read permission only' do
        Permission.create(world: world, user: user, permissions: :r)

        render partial: 'facts/index_entry', locals: { index_entry: fact }

        expect(rendered)
          .not_to have_link(href: edit_world_fact_path(world, fact))
        expect(rendered)
          .not_to have_link(href: world_fact_path(world, fact),
                            title: 'delete')
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'facts/index_entry', locals: { index_entry: fact }

        expect(rendered)
          .to have_link(href: edit_world_fact_path(world, fact))
        expect(rendered)
          .to have_link(href: world_fact_path(world, fact),
                            title: 'delete')
      end
    end
  end

  context 'unregistered user not owning public readable world' do
    let(:fact)    { create(:fact) }
    let(:world)     { fact.world }

    before(:example) do
      Permission.create(world: world, permissions: :public)

      # FIXME: `current_world` doesn't seem to be available, so work around ...
      controller.class.class_eval { include WorldAssociationController }
      allow(controller).to receive(:current_world).and_return(world)

      render partial: 'facts/index_entry', locals: { index_entry: fact }
    end

    it 'does not render crud links' do
      expect(rendered)
        .not_to have_link(href: edit_world_fact_path(world, fact))
      expect(rendered)
        .not_to have_link(href: world_fact_path(world, fact),
                          title: 'delete')
    end
  end
end


