# frozen_string_literal: true

RSpec.describe 'shared/main_menu', type: :view do
  before(:example) { render(partial: 'shared/main_menu') }

  context 'common navigation links' do
    it 'shows world index link' do
      expect(rendered).to have_link(href: worlds_path)
      expect(rendered).not_to have_link(href: new_world_path)
    end
  end

  context 'as guest user' do
    it 'shows login link' do
      expect(rendered).to have_link(href: new_user_session_path)
      expect(rendered).not_to have_link(href: edit_user_registration_path)
      expect(rendered).not_to have_link(href: users_path)
    end

    it 'does not show new world link' do
      expect(rendered).not_to have_link(href: new_world_path)
    end
  end

  context 'as normal user' do
    include_context 'Session'

    it 'shows user related links' do
      expect(rendered).to have_link(user.nick)
      expect(rendered).to have_link(href: edit_user_registration_path)
      expect(rendered).not_to have_link(href: users_path)
    end

    it 'shows new world link' do
      expect(rendered).to have_link(href: new_world_path)
    end
  end

  context 'as admin user' do
    include_context 'Admin Session'

    it 'also shows admin related links' do
      expect(rendered).to have_link(href: users_path)
    end
  end
end
