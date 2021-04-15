# frozen_string_literal: true

RSpec.describe 'Accessing world with permissions', type: :system do
  let(:world) { create(:world_with_all) }

  context 'as unregistered user' do
    context 'when world is public readable' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'does not show crud links in show view' do
        visit(world_path(world))

        # context-menu
        page.within('ul.nav.context-menu') do
          expect(page).to have_link(href: worlds_path)
          expect(page).not_to have_link(href: edit_world_path(world))
          expect(page).not_to have_link(href: new_world_path)
          expect(page)
            .not_to have_link(href: world_path(world), title: 'delete')
          expect(page)
            .not_to have_link(href: edit_world_permissions_path(world))
        end

        page.within('#notes') do
          expect(page).not_to have_link(href: /^#{new_world_note_path(world)}/)
        end
        page.within('#dossiers') do
          expect(page)
            .not_to have_link(href: /^#{new_world_dossier_path(world)}/)
        end
        page.within('#items') do
          expect(page).not_to have_link(href: new_world_item_path(world))
        end
        page.within('#figures') do
          expect(page).not_to have_link(href: new_world_figure_path(world))
        end
        page.within('#locations') do
          expect(page).not_to have_link(href: new_world_location_path(world))
        end
        page.within('#concepts') do
          expect(page).not_to have_link(href: new_world_concept_path(world))
        end
        page.within('#facts') do
          expect(page).not_to have_link(href: new_world_fact_path(world))
        end
      end

      it 'does not show crud links in index view' do
        visit(worlds_path)

        expect(page).to have_current_path(worlds_path)

        page.within('ul.nav.context-menu') do
          expect(page).not_to have_link(href: new_world_path)
        end

        expect(page).not_to have_link(href: edit_world_path(world))
        expect(page).not_to have_link(href: world_path(world), title: 'delete')
      end
    end
  end

  context 'as registered user not owning world' do
    include_context 'Session'

    context 'with only public read permissions' do
      before(:example) do
        Permission.create(world: world, permissions: :public)
      end

      it 'does not show crud links in show view' do
        visit(world_path(world))

        # context-menu
        page.within('ul.nav.context-menu') do
          expect(page).to have_link(href: worlds_path)
          expect(page).not_to have_link(href: edit_world_path(world))
          expect(page).to have_link(href: new_world_path)
          expect(page)
            .not_to have_link(href: world_path(world), title: 'delete')
          expect(page)
            .not_to have_link(href: edit_world_permissions_path(world))
        end

        page.within('#notes') do
          expect(page).not_to have_link(href: /^#{new_world_note_path(world)}/)
        end
        page.within('#dossiers') do
          expect(page)
            .not_to have_link(href: /^#{new_world_dossier_path(world)}/)
        end
        page.within('#items') do
          expect(page).not_to have_link(href: new_world_item_path(world))
        end
        page.within('#figures') do
          expect(page).not_to have_link(href: new_world_figure_path(world))
        end
        page.within('#locations') do
          expect(page).not_to have_link(href: new_world_location_path(world))
        end
        page.within('#concepts') do
          expect(page).not_to have_link(href: new_world_concept_path(world))
        end
        page.within('#facts') do
          expect(page).not_to have_link(href: new_world_fact_path(world))
        end
      end

      it 'does show crud links in index view' do
        visit(worlds_path)

        page.within('ul.nav.context-menu') do
          expect(page).to have_link(href: new_world_path)
        end

        expect(page).not_to have_link(href: edit_world_path(world))
        expect(page).not_to have_link(href: world_path(world), title: 'delete')
      end
    end

    context 'with read permissions' do
      before(:example) do
        Permission.create(world: world, user: user, permissions: :r)
      end

      it 'does not show crud links in show view' do
        visit(world_path(world))

        # context-menu
        page.within('ul.nav.context-menu') do
          expect(page).to have_link(href: worlds_path)
          expect(page).not_to have_link(href: edit_world_path(world))
          expect(page).to have_link(href: new_world_path)
          expect(page)
            .not_to have_link(href: world_path(world), title: 'delete')
          expect(page)
            .not_to have_link(href: edit_world_permissions_path(world))
        end

        page.within('#notes') do
          expect(page).not_to have_link(href: new_world_note_path(world))
        end
        page.within('#dossiers') do
          expect(page).not_to have_link(href: new_world_dossier_path(world))
        end
        page.within('#items') do
          expect(page).not_to have_link(href: new_world_item_path(world))
        end
        page.within('#figures') do
          expect(page).not_to have_link(href: new_world_figure_path(world))
        end
        page.within('#locations') do
          expect(page).not_to have_link(href: new_world_location_path(world))
        end
        page.within('#concepts') do
          expect(page).not_to have_link(href: new_world_concept_path(world))
        end
        page.within('#facts') do
          expect(page).not_to have_link(href: new_world_fact_path(world))
        end
      end

      it 'does not show crud links in index view' do
        visit(worlds_path)

        expect(page).to have_current_path(worlds_path)

        page.within('ul.nav.context-menu') do
          expect(page).to have_link(href: new_world_path)
        end

        expect(page).not_to have_link(href: edit_world_path(world))
        expect(page).not_to have_link(href: world_path(world), title: 'delete')
      end
    end

    context 'with write permissions' do
      before(:example) do
        Permission.create(world: world, user: user, permissions: :rw)
      end

      it 'does show some crud links in show view' do
        visit(world_path(world))

        # context-menu
        page.within('ul.nav.context-menu') do
          expect(page).to have_link(href: worlds_path)
          expect(page).to have_link(href: edit_world_path(world))
          expect(page).to have_link(href: new_world_path)
          expect(page)
            .not_to have_link(href: world_path(world), title: 'delete')
          expect(page)
            .not_to have_link(href: edit_world_permissions_path(world))
        end

        page.within('#notes') do
          expect(page).to have_link(href: /^#{new_world_note_path(world)}/)
        end
        page.within('#dossiers') do
          expect(page).to have_link(href: /^#{new_world_dossier_path(world)}/)
        end
        page.within('#items') do
          expect(page).to have_link(href: new_world_item_path(world))
        end
        page.within('#figures') do
          expect(page).to have_link(href: new_world_figure_path(world))
        end
        page.within('#locations') do
          expect(page).to have_link(href: new_world_location_path(world))
        end
        page.within('#concepts') do
          expect(page).to have_link(href: new_world_concept_path(world))
        end
        page.within('#facts') do
          expect(page).to have_link(href: new_world_fact_path(world))
        end
      end

      it 'does show some crud links in index view' do
        visit(worlds_path)

        expect(page).to have_current_path(worlds_path)

        page.within('ul.nav.context-menu') do
          expect(page).to have_link(href: new_world_path)
        end

        expect(page).not_to have_link(href: edit_world_path(world), count: 0)
        expect(page).not_to have_link(href: world_path(world), title: 'delete')
      end
    end
  end
end
