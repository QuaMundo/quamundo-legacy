RSpec.shared_context 'UserLogin' do |context|
  include_context 'Users'

  before(:example) do
    login
  end

  def login
    visit new_user_session_path
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
    click_button('Log in')
  end

  def logout
    visit root_path
    click_link('logout')
  end
end
