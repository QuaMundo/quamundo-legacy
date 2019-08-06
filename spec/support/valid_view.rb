RSpec.shared_examples "valid_view", type: :system do
  let (:path) { subject }
  before(:example) { visit path }

  context 'header', :comprehensive do
    it 'has a link to dashboard' do
      page.within('header') do
        page.find('[href="/"]').click
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
