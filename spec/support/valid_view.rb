RSpec.shared_examples "valid_view", type: :system do
  let (:path) { subject }
  before(:example) { visit path }

  context 'translation', :comprehensive do
    it 'is complete' do
      expect(page).to be_i18n_ready
    end

    # FIXME: Slow example!
    it 'is complete for dialog', :js, :comprehensive do
      expect(page).to have_i18n_ready_dialogs
    end
  end

  context 'header', :comprehensive do
    it 'has a link to dashboard' do
      page.within('header') do
        click_link('dashboard')
      end
      expect(page).to have_current_path(root_path)
    end

    it 'has a logout link' do
      page.within('header') do
        click_link('logout')
      end
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'has a link to user profile' do
      page.within('header') do
        click_link('profile')
      end
      expect(page).to have_current_path(edit_user_registration_path)
    end
  end
end
