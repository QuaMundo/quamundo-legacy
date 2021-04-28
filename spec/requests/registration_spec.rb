# frozen_string_literal: true

RSpec.describe 'User registration', type: :request do
  context 'as admin user' do
    include_context 'Admin Session'

    it 'can do all registration action except destroy' do
      get edit_user_registration_path
      expect(response).to have_http_status(:success)

      put user_registration_path
      expect(response).to have_http_status(:success)

      delete user_registration_path
      expect(response).to redirect_to(root_path)
      expect(User.find(user.id)).to eq(user)
    end
  end

  context 'as normal user' do
    include_context 'Session'

    it 'can edit and destroy registration' do
      get edit_user_registration_path
      expect(response).to have_http_status(:success)

      put user_registration_path
      expect(response).to have_http_status(:success)

      delete user_registration_path
      expect(response).to redirect_to(root_path)
      expect(User.find_by(id: user.id)).not_to be
    end

    it 'refuses to change nickname' do
      post_data = '{ "user": { "nick": "neuer_nick" } }'
      patch(user_registration_path, params: post_data)
      user.reload
      expect(user.nick).not_to eq('neuer_nick')
    end
  end
end
