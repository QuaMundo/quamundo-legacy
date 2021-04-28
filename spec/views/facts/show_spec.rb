# frozen_string_literal: true

RSpec.describe 'facts/show', type: :view do
  let(:fact)      { create(:fact) }
  let(:world)     { fact.world }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)

    assign(:fact, fact)
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
          .to have_link(href: world_facts_path(world))
        expect(rendered)
          .not_to have_link(href: edit_world_fact_path(world, fact))
        expect(rendered)
          .not_to have_link(href: new_world_fact_path(world))
        expect(rendered)
          .not_to have_link(href: world_fact_path(world, fact),
                            title: 'delete')
      end
    end

    context 'non public readable world' do
    end
  end

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:fact)    { create(:fact, user: user) }
    end

    context 'not owning world' do
      context 'without permissions' do
        # FIXME: This should not render at all!
        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered)
            .to have_link(href: world_facts_path(world))
          expect(rendered)
            .not_to have_link(href: edit_world_fact_path(world, fact))
          expect(rendered)
            .not_to have_link(href: new_world_fact_path(world))
          expect(rendered)
            .not_to have_link(href: world_fact_path(world, fact),
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
            .to have_link(href: world_facts_path(world))
          expect(rendered)
            .not_to have_link(href: edit_world_fact_path(world, fact))
          expect(rendered)
            .not_to have_link(href: new_world_fact_path(world))
          expect(rendered)
            .not_to have_link(href: world_fact_path(world, fact),
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
            .to have_link(href: world_facts_path(world))
          expect(rendered)
            .to have_link(href: edit_world_fact_path(world, fact))
          expect(rendered)
            .to have_link(href: new_world_fact_path(world))
          expect(rendered)
            .to have_link(href: world_fact_path(world, fact),
                          title: 'delete')
        end
      end
    end
  end
end
