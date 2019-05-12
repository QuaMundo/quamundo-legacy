RSpec.describe 'Figures', type: :request do
  include_context 'Users'

  context 'without user logged in' do
    pending("Test figures without logged in user")
  end

  context 'withuser logged in', login: :user_with_worlds do
    include_context 'Session'

    it 'shows worlds figures index', :comprehensive do
      get world_figures_path(world)
      expect(response).to be_successful
    end
  end
end
