RSpec.describe 'Showing a world', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }
  let(:other_world) { other_user_with_worlds.worlds.first }

  context 'own worlds' do
    before(:example) { visit world_path(world) }

    it 'shows details of world' do
      expect(page).to have_content(world.title)
      expect(page).to have_content(world.description)
      page.within('div.card-footer nav.context-menu') do
        expect(page).to have_link(href: world_path(world),
                                  class: 'nav-link',
                                  title: 'delete')
        expect(page).to have_link(href: edit_world_path(world),
                                  class: 'nav-link')
        expect(page).to have_link(href: worlds_path, class: 'nav-link')
        expect(page).to have_link(href: new_world_path, class: 'nav-link')
      end
    end

    context 'item statistics' do
      specify 'figure statistics' do
        skip('To be implemented')
      end

      specify 'item statistics'
      specify 'location statistics'
      specify 'event statistics'
    end

    it_behaves_like 'valid_view' do
      let(:subject) { world_path(world) }
    end
  end

  context 'other users worlds' do
    before(:example) { visit world_path(other_world) }

    it 'does not show world not owned by logged in user' do
      expect(current_path).not_to eq(world_path(other_world))
      expect(current_path).to eq(worlds_path)
      expect(page).to have_selector('aside.alert-danger',
                                   text: 'This is not')
    end
  end
end
