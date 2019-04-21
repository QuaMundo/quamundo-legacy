RSpec.shared_examples "valid_view", type: :system do
  let (:path) { subject }
  before(:example) { visit path }

  context 'translation', :comprehensive do
    it 'does not miss one' do
      expect(page).not_to have_selector('span.translation_missing')
      expect(page).not_to have_selector('[title*="translation_missing"]')
    end
  end

  context 'header', :comprehensive do
    it 'has a link to dashboard' do
      page.within('header') do
        click_link('dashboard')
      end
      expect(current_path).to eq(root_path)
    end

    it 'has a logout link' do
      page.within('header') do
        click_link('logout')
      end
      expect(current_path).to eq(new_user_session_path)
    end

    it 'has a link to user profile' do
      page.within('header') do
        click_link('profile')
      end
      expect(current_path).to eq(edit_user_registration_path)
    end
  end
end
