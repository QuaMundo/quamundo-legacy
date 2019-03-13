RSpec.describe 'Registration', type: :system do
  context 'new registration' do
    context 'incomplete' do
      before(:example) { visit new_user_registration_path }


      # Since we use `devise` gem, filling in email and password fields is
      # assumed to already being tested, so we just test for custom fields here
      scenario 'with nick missing returns to registration' do
        fill_in('Email', with: 'test@example.com')
        fill_in('Password', with: 's3cr3t')
        fill_in('Password confirmation', with: 's3cr3t')
        click_button('Sign up')
        expect(current_path).to eq(user_registration_path)
        expect(page).to have_css('aside.alert')
      end
    end

    context 'complete' do
      before(:example) { visit new_user_registration_path }

      it 'succeeds to dashboard' do
        fill_in('Username', with: 'NICK')
        fill_in('Email', with: 'test@example.com')
        fill_in('Password', with: 's3cr3t')
        fill_in('Password confirmation', with: 's3cr3t')
        click_button('Sign up')
        expect(current_path).to eq(root_path)
      end
    end
  end

  context 'update registration' do
    include_context 'UserLogin'

    before(:example) { visit edit_user_registration_path }

    it 'has nickname set read-only' do
      expect(page).to have_field('Username', disabled: true)
    end
  end
end
