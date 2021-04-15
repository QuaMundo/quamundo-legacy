# frozen_string_literal: true

RSpec.describe 'relations/index', type: :view do
  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:relation)  { create(:relation, user: user) }
      let(:fact)      { relation.fact }
      let(:world)     { fact.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render(
          partial: 'relations/index_entry',
          locals: { index_entry: relation }
        )
      end

      it 'shows a relation index entry' do
        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{relation.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description',
                            text: /#{relation.description}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{relation.relatives.count}/
        expect(rendered).to match /#{relation.subjects.count}/

        expect(rendered).to have_link(
          href: world_fact_relation_path(world, fact, relation)
        )
        expect(rendered).to have_link(
          href: edit_world_fact_relation_path(world, fact, relation)
        )
        expect(rendered).to have_link(
          href: world_fact_relation_path(world, fact, relation),
          id: /delete-.+/
        )
      end
    end

    context 'not owning world' do
      let(:relation)  { create(:relation) }
      let(:fact)      { relation.fact }
      let(:world)     { fact.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)
      end

      it 'does not show crud links with read permission only' do
        Permission.create(world: world, user: user, permissions: :r)

        render(
          partial: 'relations/index_entry',
          locals: { index_entry: relation }
        )

        expect(rendered).not_to have_link(
          href: edit_world_fact_relation_path(world, fact, relation)
        )
        expect(rendered).not_to have_link(
          href: world_fact_relation_path(world, fact, relation),
          title: 'delete'
        )
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render(
          partial: 'relations/index_entry',
          locals: { index_entry: relation }
        )

        expect(rendered).to have_link(
          href: edit_world_fact_relation_path(world, fact, relation)
        )
        expect(rendered).to have_link(
          href: world_fact_relation_path(world, fact, relation),
          title: 'delete'
        )
      end
    end
  end

  context 'unregistered user not owning public readable world' do
    let(:relation)  { create(:relation) }
    let(:fact)      { relation.fact }
    let(:world)     { fact.world }

    before(:example) do
      Permission.create(world: world, permissions: :public)

      # FIXME: `current_world` doesn't seem to be available, so work around ...
      controller.class.class_eval { include WorldAssociationController }
      allow(controller).to receive(:current_world).and_return(world)

      render(
        partial: 'relations/index_entry',
        locals: { index_entry: relation }
      )
    end

    it 'does not render crud links' do
      expect(rendered).not_to have_link(
        href: edit_world_fact_relation_path(world, fact, relation)
      )
      expect(rendered).not_to have_link(
        href: world_fact_relation_path(world, fact, relation),
        title: 'delete'
      )
    end
  end
end
