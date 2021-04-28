# frozen_string_literal: true

RSpec.describe 'concepts/index', type: :view do
  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:concept) { create(:concept, user: user) }
      let(:world) { concept.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)

        render partial: 'concepts/index_entry', locals: { index_entry: concept }
      end

      it 'shows a concept index entry' do
        expect(rendered).to have_selector('li.index_entry')
        expect(rendered)
          .to have_selector('.index_entry_name', text: /#{concept.name}/)
        expect(rendered)
          .to have_selector('.index_entry_description',
                            text: /#{concept.description}/)
        expect(rendered).to match /#{world.name}/
        expect(rendered).to match /#{concept.facts.count}/
        expect(rendered).to match /#{concept.relatives.count}/

        expect(rendered)
          .to have_link(href: world_concept_path(world, concept))
        expect(rendered)
          .to have_link(href: edit_world_concept_path(world, concept))
        expect(rendered)
          .to have_link(href: world_concept_path(world, concept),
                        id: /delete-.+/)
      end
    end

    context 'not owning world' do
      let(:concept) { create(:concept) }
      let(:world) { concept.world }

      before(:example) do
        # FIXME: `current_world` doesn't seem to be available, so work around ...
        controller.class.class_eval { include WorldAssociationController }
        allow(controller).to receive(:current_world).and_return(world)
      end

      it 'does not show crud links with read permission only' do
        Permission.create(world: world, user: user, permissions: :r)

        render partial: 'concepts/index_entry', locals: { index_entry: concept }

        expect(rendered)
          .not_to have_link(href: edit_world_concept_path(world, concept))
        expect(rendered)
          .not_to have_link(href: world_concept_path(world, concept),
                            title: 'delete')
      end

      it 'does show crud links with read-write permissions' do
        Permission.create(world: world, user: user, permissions: :rw)

        render partial: 'concepts/index_entry', locals: { index_entry: concept }

        expect(rendered)
          .to have_link(href: edit_world_concept_path(world, concept))
        expect(rendered)
          .to have_link(href: world_concept_path(world, concept),
                        title: 'delete')
      end
    end
  end

  context 'unregistered user not owning public readable world' do
    let(:concept) { create(:concept) }
    let(:world) { concept.world }

    before(:example) do
      Permission.create(world: world, permissions: :public)

      # FIXME: `current_world` doesn't seem to be available, so work around ...
      controller.class.class_eval { include WorldAssociationController }
      allow(controller).to receive(:current_world).and_return(world)

      render partial: 'concepts/index_entry', locals: { index_entry: concept }
    end

    it 'does not render crud links' do
      expect(rendered)
        .not_to have_link(href: edit_world_concept_path(world, concept))
      expect(rendered)
        .not_to have_link(href: world_concept_path(world, concept),
                          title: 'delete')
    end
  end
end
