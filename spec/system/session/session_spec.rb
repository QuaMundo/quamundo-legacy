RSpec.describe 'Session', type: :system do
  context 'Without user logged in' do
    scenario 'Visiting dashboard redirects to login page' do
      visit root_path
      expect(page).to have_current_path(root_path)
    end
  end

  context 'With user logged in' do
    include_context 'UserLogin'

    scenario 'User is redirected to dashboard after login' do
      expect(page).to have_current_path(root_path)
    end

    scenario 'User is redirected to login after logout' do
      logout
      expect(page).to have_current_path(root_path)
    end
  end
end
