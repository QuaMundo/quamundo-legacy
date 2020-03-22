RSpec.describe 'concepts/show', type: :view do
  let(:concept)      { create(:concept) }
  let(:world)     { concept.world }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)

    assign(:concept, concept)
    assign(:world, world)
  end

  context 'unregistered user' do
    context 'public readable world' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'shows only world and index link' do
        render
        expect(rendered)
          .to have_link(href: world_path(world))
        expect(rendered)
          .to have_link(href: world_concepts_path(world))
        expect(rendered)
          .not_to have_link(href: edit_world_concept_path(world, concept))
        expect(rendered)
          .not_to have_link(href: new_world_concept_path(world))
        expect(rendered)
          .not_to have_link(href: world_concept_path(world, concept),
                            title: 'delete')
      end
    end

    context 'non public readable world' do
    end
  end

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:concept)    { create(:concept, user: user) }

    end

    context 'not owning world' do
      context 'without permissions' do
        # FIXME: This should not render at all!
        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_concepts_path(world))
          expect(rendered)
            .not_to have_link(href: edit_world_concept_path(world, concept))
          expect(rendered)
            .not_to have_link(href: new_world_concept_path(world))
          expect(rendered)
            .not_to have_link(href: world_concept_path(world, concept),
                              title: 'delete')
        end
      end

      context 'with read permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :r)
        end

        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_concepts_path(world))
          expect(rendered)
            .not_to have_link(href: edit_world_concept_path(world, concept))
          expect(rendered)
            .not_to have_link(href: new_world_concept_path(world))
          expect(rendered)
            .not_to have_link(href: world_concept_path(world, concept),
                              title: 'delete')
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :rw)
        end

        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_concepts_path(world))
          expect(rendered)
            .to have_link(href: edit_world_concept_path(world, concept))
          expect(rendered)
            .to have_link(href: new_world_concept_path(world))
          expect(rendered)
            .to have_link(href: world_concept_path(world, concept),
                              title: 'delete')
        end
      end
    end
  end
end


