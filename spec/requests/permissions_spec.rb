# frozen_string_literal: true

RSpec.describe 'Permisssions', type: :request do
  context 'without user logged in' do
    let(:world) { create(:world) }

    it 'redirects to login when requesting permissions form' do
      get edit_world_permissions_path(world)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'with user logged in' do
    include_context 'Session'

    context 'accessing own worlds permissions' do
      let(:world) { create(:world, user: user) }

      it 'renders form' do
        get edit_world_permissions_path(world)
        expect(response).to have_http_status(:success)
      end
    end

    context 'accessing other users worlds permissions' do
      let(:world) { create(:world) }

      it 'redirects to worlds index' do
        get edit_world_permissions_path(world)
        expect(response).to redirect_to(worlds_path)
      end

      it 'redirects to worlds index even if user has write perms to world' do
        Permission.create(world: world, user: user, permissions: :rw)
        get edit_world_permissions_path(world)
        expect(response).to redirect_to(worlds_path)
      end
    end
  end
end
