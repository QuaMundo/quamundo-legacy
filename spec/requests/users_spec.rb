# frozen_string_literal: true

RSpec.describe 'User', type: :request do
  context 'as admin user' do
    include_context 'Admin Session'

    it 'can create new users' do
      get new_user_path
      expect(response).to have_http_status(:success)

      user_params = { user: {
        nick: 'new_user_42',
        email: 'new_user@quamundo.de',
        password: 'secret',
        password_confirmation: 'secret'
      } }
      post users_path, params: user_params
      expect(response).to redirect_to users_path
    end

    it 'can list all users' do
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  context 'as normal user' do
    include_context 'Session'

    it 'cannot create users' do
      get new_user_path
      expect(response).to redirect_to root_path
    end

    it 'cannot list users' do
      get users_path
      expect(response).to redirect_to root_path
    end
  end
end
