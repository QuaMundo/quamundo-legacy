RSpec.feature 'Worlds', type: :feature do
  context 'with user logged in', login: :user_with_worlds do
    include_context 'Session'

    context 'accessing own worlds'do
      it 'shows index of users worlds' do
        world = user_with_worlds.worlds.first
        other_world = other_user_with_worlds.worlds.first
        visit(worlds_path)
        expect(page).to have_selector('button', text: world.title)
        expect(page).not_to have_selector('button', text: other_world.title)
        expect(page).to have_link('list', href: worlds_path,
                                  class: 'nav-item')
        expect(page).to have_link('new', href: new_world_path,
                                  class: 'nav-item')
      end

      it 'shows details of world' do
        world = user_with_worlds.worlds.first
        other_world = other_user_with_worlds.worlds.first
        visit(world_path(world))
        expect(page).to have_content(world.title)
        expect(page).to have_content(world.description)
        page.find('nav.context-menu') do
          expect(page).to have_link(href: world_path(world), class: 'nav-link')
          expect(page).to have_link(href: edit_world_path(world),
                                    class: 'nav-link')
          expect(page).to have_link(href: worlds_path, class: 'nav-link')
          expect(page).to have_link(href: new_world_path, class: 'nav-link')
        end
      end
    end

    context 'creation' do
      it 'is successfull with completed form' do
        world_count = user_with_worlds.worlds.count
        visit new_world_path
        fill_in('Title', with: 'One More new World')
        fill_in('Description', with: 'Description of newly created world')
        click_button('submit')
        expect(user_with_worlds.worlds.count).to eq(world_count + 1)
        expect(page).to have_content('One More new World')
      end

      it 'is successfully with completed form and image attached' do
        visit new_world_path
        fill_in('Title', with: 'One More new World with image')
        page.attach_file('world_image', fixture_file_name('earth.jpg'))
        click_button('submit')
        expect(page).to have_selector('img.world-image')
      end

      it 'redirects to new form if title is missing' do
        visit new_world_path
        click_button('submit')
        expect(page).to have_css('.alert', text: 'Title')
      end
    end

    context 'update' do
      include_context 'Worlds'

      it 'title and description can be changed' do
        world = user_with_worlds.worlds.first
        visit edit_world_path(world)
        fill_in('Title', with: 'The New Title')
        fill_in('Description', with: 'A new description')
        click_button('submit')
        expect(current_path).to eq(world_path(world))
        expect(page).to have_content('The New Title')
        expect(page).to have_content('A new description')
      end

      it 'redirects to edit form if title is empty' do
        world = user_with_worlds.worlds.first
        visit edit_world_path(world)
        fill_in('Title', with: nil)
        click_button('submit')
        expect(page).to have_css('.alert', text: 'Title')
      end

      it 'attaches an image' do
        world = user_with_worlds.worlds.first
        visit edit_world_path(world)
        page.attach_file('world_image', fixture_file_name('earth.jpg'))
        click_button('submit')
        expect(current_path).to eq(world_path(world))
        expect(world.image).to be_attached
        expect(page).to have_selector('img.world-image')
      end

      it 'refuse to attache non image files' do
        world = user_with_worlds.worlds.first
        visit edit_world_path(world)
        page.attach_file('world_image', fixture_file_name('file.pdf'))
        click_button('submit')
        expect(current_path).to eq(world_path(world))
        expect(world.image).not_to be_attached
        pending("First find out how errors and flash work")
        expect(page).to have_selector('.alert', text: 'Only images may be')
      end

      # OPTIMIZE: Maybe this example isn't needed since this should be handled
      # by ActiveStorage!?
      it 'removes old images and variants on update',
        login: :world_with_user, optional: true do

        # OPTIMIZE: Needs refactoring
        visit edit_world_path(world)
        old_key = world.image.key
        image_path = generate_some_image_paths(world)
        page.attach_file('world_image', fixture_file_name('htrae.jpg'))
        click_button('submit')
        expect(image_path.none? { |f| File.exist? f }).to be_truthy
        expect(world.reload.image.key).not_to eq(old_key)
        # FIXME: Without this, `sign_out world.user` in shared_context
        # `Worlds` doesn't work!
        world.user.reload
      end
    end

    context 'deletion' do
      it 'brings apocalypse', :js do
        world = user_with_worlds.worlds.last
        visit(world_path(world))
        page.accept_confirm() do
          page.find('nav.context-menu a.nav-link', text: 'delete').click
        end
        expect(current_path).to eq(worlds_path)
        expect(World.find_by(id: world.id)).to be_falsey
      end
    end

    context 'I18n' do
      let(:world) { user_with_worlds.worlds.first }

      it_behaves_like "i18ned" do
        let(:path) { worlds_path }
      end

      it_behaves_like "i18ned" do
        let(:path) { world_path(world) }
      end

      it_behaves_like "i18ned" do
        let(:path) { edit_world_path(world) }
      end

      it_behaves_like "i18ned" do
        let(:path) { new_world_path }
      end
    end

    context 'accessing someone elses worlds'
  end
end
