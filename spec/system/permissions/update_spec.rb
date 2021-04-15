# frozen_string_literal: true

RSpec.describe 'Updating/Editing a worlds permissions', type: :system do
  include_context 'Session'

  let!(:user_a)   { create(:user) }
  let!(:user_b)   { create(:user) }
  let!(:user_c)   { create(:user) }

  context 'in users own world' do
    let(:world) { create(:world, user: user) }

    it 'shows existing permissions', :js do
      perm1 = Permission.create(world: world, user: user_a, permissions: :rw)
      perm2 = Permission.create(world: world, permissions: :public)
      perm3 = Permission
              .create(world: build_stubbed(:world), user: user_b, permissions: :r)

      visit edit_world_permissions_path(world)

      page.within('div', id: element_id(perm1, 'selected')) do
        expect(page).to have_selector('input[value="read and write"]')
        expect(page).to have_selector("input[value=\"#{user_a.nick}\"]")
        expect(page)
          .to have_selector("input[value=\"#{perm1.id}\"]", visible: false)
      end

      page.within('div', id: element_id(perm2, 'selected')) do
        expect(page).to have_selector('input[value="public readable"]')
        expect(page).to have_selector('input:not([value])')
        expect(page)
          .to have_selector("input[value=\"#{perm2.id}\"]", visible: false)
      end

      page.within('#new-permissions select[id$="_user_id"]') do
        expect(page)
          .to have_selector('option[disabled]', text: user_a.nick)
      end

      expect(page)
        .not_to have_selector('div', id: element_id(perm3, 'selected'))

      expect(page)
        .to have_selector('input[id$="_destroy"]', visible: false, count: 2)
    end

    it 'can add and remove permissions', :js do
      perm1 = Permission.create(world: world, user: user_a, permissions: :rw)
      _perm2 = Permission.create(world: world, permissions: :public)

      visit edit_world_permissions_path(world)

      # user_a should be disabled in select list
      page.within('#new-permissions') do
        expect(page).to have_selector('option[disabled]', text: user_a.nick)
      end

      # Remove permissions for user_a
      page.within('div', id: element_id(perm1, 'selected')) do
        find('button').click
        expect(page).to have_selector(
          'input[id$="_destroy"][type="hidden"][value="1"]', visible: false
        )
      end

      # Insert `user reenabled` here

      expect(page).to have_selector(
        'div',
        id: element_id(perm1, 'selected'),
        class: /d-none/,
        visible: false
      )

      # Add a new permission :r to user_b
      page.find('select', id: /-1_permissions$/).select('read only')
      page.find('select', id: /-1_user_id$/).select(user_b.nick)
      click_button(id: 'add-permissions')
      page.within('#new-permissions select[id$="-1_user_id"]') do
        expect(page).to have_selector('option[disabled]', text: user_b.nick)
      end
      page.within('div#new-permissions') do
        expect(page)
          .to have_selector("input[value=\"#{user_b.id}\"]", visible: false)
        expect(page).to have_selector("input[value=\"#{user_b.nick}\"]")
        expect(page).to have_selector('input[value="read only"]')
        expect(page).to have_selector('input[value="r"]', visible: false)
      end

      # Add another permission :rw to user_c
      page.find('select', id: /-1_permissions$/).select('read only')
      page.find('select', id: /-1_user_id$/).select(user_c.nick)

      # Remove user_b permissions
      page.within('#permissions-input') do
        page
          .find("input[value=\"#{user_b.nick}\"]+div button")
          .click
        expect(page).not_to have_selector("input[value=\"#{user_b.nick}\"]")
        expect(page)
          .not_to have_selector("input[value=\"#{user_b.id}\"]", visible: false)
      end

      # Submit
      click_button('submit')

      expect(page).to have_current_path(world_path(world))
      world.reload

      expect(world.permissions.find_by(permissions: :public)).to be
      expect(world.permissions.find_by(permissions: :r, user: user_a)).to be_nil
      expect(world.permissions.find_by(permissions: :r, user: user_c)).to be
      expect(world.permissions.count).to eq(2)

      # Move hunk to: Insert `user reenabled` here
      pending(
        'Not implemented yet - '\
        'see app/javascript/controllers/permissions_controller.js'
      )
      expect(page).to have_selector(
        "#new-permissions select option:not([disabled])[value=\"#{user_a.id}\"]"
      )
    end

    it 'can choose public only once', :js do
      perm1 = Permission.create(world: world, permissions: :public)

      visit edit_world_permissions_path(world)

      page.within('#new-permissions') do
        expect(page).to have_selector(
          'select[id$=_permissions] option[value="public"][disabled]'
        )
      end

      page.within('div', id: element_id(perm1, 'selected')) do
        page.find('button').click
      end
      page.within('#new-permissions') do
        pending(
          'Not implemented yet - '\
          'see app/javascript/controllers/permissions_controller.js'
        )
        expect(page).to have_selector(
          'select[id$=_permissions] option:not([disabled])[value="public"]'
        )
      end
    end
  end

  context 'in another users world' do
    let(:world) { create(:world) }

    before(:example) do
      Permission.create(user: user, world: world, permissions: :rw)
    end

    it 'does not show permissions form' do
      visit edit_world_permissions_path(world)
      expect(page).to have_current_path(worlds_path)
    end
  end
end
