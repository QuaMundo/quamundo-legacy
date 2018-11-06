RSpec.describe 'Dashboard', type: :request, login: :user do
  include_context 'Session'

  before(:example) { get root_path }

  it 'does not redirect to login if session is established' do
    expect(response).not_to redirect_to(new_user_session_path)
  end
  
  it 'renders partial worlds' do
    expect(response).to render_template('dashboard/index')
    expect(response).to render_template(partial: 'worlds/_overview')
  end
end
