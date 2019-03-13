RSpec.describe 'Worlds', type: :request do
  include_context 'Users'

  context 'without user logged in' do
    let(:world) { create(:world, title: 'Welt', user: user) }

    # FIXME: Can this be abstracted? It's not DRY
    it 'redirects to login when world index ist requested' do
      get worlds_path
      expect_login_path
    end

    it 'redirects to login when world show is requested' do
      get world_path(world)
      expect_login_path
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
      post_data = '{ "world": { "title": "Neuer Titel" } }'
      patch world_path(world), params: post_data
      expect_login_path
    end

    private
    def expect_login_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'with logged in user', login: :user_with_worlds do
    include_context 'Session'

    context 'regarding own worlds' do
      it 'can destroy a world' do
        world = user_with_worlds.worlds.first
        delete world_path(world)
        expect(World.find_by(id: world.id)).to be_falsy
      end

      it 'must not update title' do
        world = user_with_worlds.worlds.first
        old_title = world.title
        headers = { "CONTENT_TYPE" => "application/json" }
        post_data = '{ "world": { "title": "A New Title" } }'
        patch(world_path(world), params: post_data, headers: headers)
        world.reload
        expect(world.title).to eq(old_title)
      end
    end

    context 'regarding other users worlds' do
      let(:other_world) { other_world = other_user_with_worlds.worlds.first }

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
        expect(response.body).not_to include(other_world.title)
        expect(response.body).to include(user_with_worlds.worlds.first.title)
      end
    end
  end
end
