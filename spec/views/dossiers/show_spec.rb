# frozen_string_literal: true

RSpec.describe 'dossiers/show', type: :view do
  let(:world)     { create(:world_with_dossiers, dossiers_count: 1) }
  let(:dossier)   { world.dossiers.first }

  before(:example) do
    # FIXME: `current_world` doesn't seem to be available, so work around ...
    controller.class.class_eval { include WorldAssociationController }
    allow(controller).to receive(:current_world).and_return(world)

    assign(:dossier, dossier)
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
        expect(rendered).to have_link(
          href: polymorphic_path(
            [dossier.dossierable.try(:world), dossier.dossierable]
          )
        )
        expect(rendered)
          .not_to have_link(href: edit_dossier_path(dossier))
        expect(rendered).not_to have_link(
          href: new_polymorphic_path(
            [dossier.dossierable.try(:world), dossier.dossierable, Dossier]
          )
        )
        expect(rendered)
          .not_to have_link(href: dossier_path(dossier), title: 'delete')
      end
    end

    context 'non public readable world' do
    end
  end

  context 'registered user' do
    include_context 'Session'

    context 'owning world' do
      let(:world)   { create(:world_with_dossiers, user: user, dossiers_count: 1) }
    end

    context 'not owning world' do
      context 'without permissions' do
        # FIXME: This should not render at all!
        it 'shows only world and index link' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered).to have_link(
            href: polymorphic_path(
              [dossier.dossierable.try(:world), dossier.dossierable]
            )
          )
          expect(rendered)
            .not_to have_link(href: edit_dossier_path(dossier))
          expect(rendered).not_to have_link(
            href: new_polymorphic_path(
              [dossier.dossierable.try(:world), dossier.dossierable, Dossier]
            )
          )
          expect(rendered)
            .not_to have_link(href: dossier_path(dossier),
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
          expect(rendered).to have_link(
            href: polymorphic_path(
              [dossier.dossierable.try(:world), dossier.dossierable]
            )
          )
          expect(rendered)
            .not_to have_link(href: edit_dossier_path(dossier))
          expect(rendered).not_to have_link(
            href: new_polymorphic_path(
              [dossier.dossierable.try(:world), dossier.dossierable, Dossier]
            )
          )
          expect(rendered)
            .not_to have_link(href: dossier_path(dossier),
                              title: 'delete')
        end
      end

      context 'with read-write permissions' do
        before(:example) do
          Permission.create(user: user, world: world, permissions: :rw)
        end

        it 'shows all crud links' do
          render
          expect(rendered)
            .to have_link(href: world_path(world))
          expect(rendered).to have_link(
            href: polymorphic_path(
              [dossier.dossierable.try(:world), dossier.dossierable]
            )
          )
          expect(rendered)
            .to have_link(href: edit_dossier_path(dossier))
          expect(rendered).to have_link(
            href: new_polymorphic_path(
              [dossier.dossierable.try(:world), dossier.dossierable, Dossier]
            )
          )
          expect(rendered)
            .to have_link(href: dossier_path(dossier),
                          title: 'delete')
        end
      end
    end
  end
end
