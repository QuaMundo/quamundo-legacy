RSpec.describe 'Registration', type: :request, login: :user do
  include_context 'Session'

  context 'Update' do
    it 'refuses to change nickname' do
      post_data = '{ "user": { "nick": "neuer_nick" } }'
      patch(user_registration_path, params: post_data)
      user.reload
      expect(user.nick).not_to eq('neuer_nick')
    end
  end
end
