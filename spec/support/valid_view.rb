RSpec.shared_examples "valid_view", type: :system do
  let (:path) { subject }
  before(:example) { visit path }

  context 'translation', :comprehensive do
    it 'does not miss one' do
      expect(page).not_to have_selector('span.translation_missing')
      expect(page).not_to have_selector('[title*="translation_missing"]')
    end

    # FIXME: Slow example!
    it 'does not miss one in dialogs', :js, :comprehensive do
      if page.has_selector?('a.nav-link[title="delete"]')
        res = page.accept_confirm {
          page.first('nav.context-menu a.nav-link[title="delete"]').click
        }
        expect(res).not_to match(/translation missing/i)
      end
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
