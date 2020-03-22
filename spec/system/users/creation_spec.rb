RSpec.describe 'Creating a user', type: :system do
  include_context 'Admin Session'

  let(:other_user)    { create(:user) }

  before(:example) { visit new_user_path }

  it 'is successfully with completed form' do
    fill_in('Username', with: 'newbie')
    fill_in('Email', with: 'a@bc.de')
    fill_in('Password', with: '123456')
    fill_in('Password confirmation', with: '123456')
    click_button('Sign up')
    expect(page).to have_current_path(users_path)
    expect(page).to have_content('newbie')
    expect(page).to have_content('a@bc.de')
  end

  it 'refuses creation without nick' do
    fill_in('Username', with: nil)
    fill_in('Email', with: 'a@bc.de')
    fill_in('Password', with: '123456')
    fill_in('Password confirmation', with: '123456')
    click_button('Sign up')
    expect(page).to have_css('.alert', text: /failed to create/i)
  end

  it 'refuses creation without email' do
    fill_in('Username', with: 'newbie')
    fill_in('Email', with: nil)
    fill_in('Password', with: '123456')
    fill_in('Password confirmation', with: '123456')
    click_button('Sign up')
    expect(page).to have_css('.alert', text: /failed to create/i)
  end

  it 'refuses creation of dublicate nick' do
    fill_in('Username', with: other_user.nick)
    fill_in('Email', with: 'a@bc.de')
    fill_in('Password', with: '123456')
    fill_in('Password confirmation', with: '123456')
    click_button('Sign up')
    expect(page).to have_css('.alert', text: /failed to create/i)
  end

  it 'refuses creation of dublicate email' do
    fill_in('Username', with: 'newbie')
    fill_in('Email', with: other_user.email)
    fill_in('Password', with: '123456')
    fill_in('Password confirmation', with: '123456')
    click_button('Sign up')
    expect(page).to have_css('.alert', text: /failed to create/i)
  end

  it_behaves_like 'valid_view' do
    let(:subject) { new_user_path }
  end
end
