# frozen_string_literal: true

RSpec.describe 'Dashboard', type: :request do
  include_context 'Session'

  before(:example) { get root_path }

  it 'does not redirect to login if session is established', :comprehensive do
    expect(response).not_to redirect_to(new_user_session_path)
  end
end
