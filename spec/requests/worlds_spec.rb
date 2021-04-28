# frozen_string_literal: true

RSpec.describe 'Worlds', type: :request do
  context 'without user logged in' do
    let(:world) { create(:world, name: 'Welt') }

    context 'if world is not public readable' do
      it 'redirects to login when world index ist requested' do
        get worlds_path
        pending('FIXME: Index view for unregistered visitor should show '\
                'empty list')
        expect_login_path
      end

      it 'redirects to index when world show is requested' do
        get world_path(world)
        expect(response).to redirect_to worlds_path
      end

      it 'redirects to login when world create is requested' do
        get new_world_path
        expect_login_path
      end

      it 'redirects to login when world edit is requested' do
        get edit_world_path(world)
        expect_login_path
      end

      it 'redirects to login when world destroy is requested' do
        delete world_path(world)
        expect_login_path
      end

      it 'redirects to login when world update is requested' do
        post_data = '{ "world": { "name": "Neuer Titel" } }'
        patch world_path(world), params: post_data
        expect_login_path
      end

      context 'if world is public readable' do
        before(:example) do
          Permission.create(world: world, permissions: :public)
        end

        it 'renders show view' do
          get world_path(world)
          expect(response).to have_http_status(:success)
        end

        it 'renders index view' do
          get worlds_path
          expect(response).to have_http_status(:success)
        end

        it 'redirects to login when new is requested' do
          get new_world_path
          expect(response).to redirect_to(new_user_session_path)
        end

        it 'redirects to login when create is requested' do
          post worlds_path
          expect(response).to redirect_to(new_user_session_path)
        end

        it 'redirects to login when edit is requested' do
          get edit_world_path(world)
          expect(response).to redirect_to(new_user_session_path)
        end

        it 'redirects to login when update is requested' do
          put world_path(world)
          expect(response).to redirect_to(new_user_session_path)
        end

        it 'redirects to login when destroy is requested' do
          delete world_path(world)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    private

    def expect_login_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'with logged in user' do
    include_context 'Session'

    let(:user) { build(:user_with_worlds_wo_img) }
    let(:other_world) { create(:world) }

    context 'regarding own worlds' do
      it 'can destroy a world' do
        world = user.worlds.first
        delete world_path(world)
        expect(World.find_by(id: world.id)).to be_falsy
      end

      it 'must not update name' do
        world = user.worlds.first
        old_name = world.name
        headers = { 'CONTENT_TYPE' => 'application/json' }
        post_data = '{ "world": { "name": "A New Title" } }'
        patch(world_path(world), params: post_data, headers: headers)
        world.reload
        expect(world.name).to eq(old_name)
      end
    end

    context 'regarding other users worlds' do
      it 'refuses to destroy world of other user' do
        get world_path(other_world)
        expect(response).to redirect_to(worlds_path)
      end

      it 'refuses to edit other users world' do
        get edit_world_path(other_world)
        expect(response).to redirect_to(worlds_path)
      end

      it 'refuses to update other users world' do
        patch world_path(other_world)
        expect(response).to redirect_to(worlds_path)
      end

      it 'refuses to delete other users world' do
        delete world_path(other_world)
        expect(response).to redirect_to(worlds_path)
      end

      it 'allows to create a new world' do
        get new_world_path
        expect(response).to be_successful
      end

      it 'allows to show index of own worlds' do
        get worlds_path
        expect(response).to be_successful
        expect(response.body).not_to include(other_world.name)
        expect(response.body).to include(user.worlds.first.name)
      end
    end
  end
end
