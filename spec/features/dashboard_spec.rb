RSpec.feature 'Dashboard' do
  include_context 'Session'

  before { visit root_path }

  context 'for user without a world', login: :user do
    it 'shows invitation to create a world' do
      page.find('.jumbotron') do
        click_link('create a world', href: new_world_path)
      end
      expect(current_path).to eq(new_world_path)
    end
  end

  context 'for user with worlds', login: :user_with_worlds do
    context 'Worlds overview' do
      it 'has a card linking to world details' do
        world = user_with_worlds.worlds.first
        visit root_path
        click_link('show', class: 'card-link', href: world_path(world))
        expect(current_path).to eq(world_path(world))
      end

      it 'shows world image in card' do
        world = create(:world_with_image, user: user_with_worlds)
        file = world.image.filename
        visit root_path
        expect(page)
          .to have_selector("img.card-img-top[src*=\"#{file}\"]")
      end
    end

    # FIXME: Is this the right place? Footer menu should be rendered always!
    context 'Footer menu' do
      it 'has a link to dashboard' do
        page.find('footer') do
          click_link('dashboard')
        end
        expect(current_path).to eq(root_path)
      end

      it 'has a logout link' do
        page.find('footer') do
          click_link('logout')
        end
        expect(current_path).to eq(new_user_session_path)
      end

      it 'has a link to user profile' do
        page.find('footer') do
          click_link('profile')
        end
        expect(current_path).to eq(edit_user_registration_path)
      end
    end
  end

  context 'I18n' do
    it_behaves_like "i18ned" do
      let(:path) { root_path }
    end
  end
end
