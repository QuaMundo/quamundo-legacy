RSpec.describe 'Listing worlds', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.first }
  let(:other_world) { other_user_with_worlds.worlds.first }

  before(:example) { visit worlds_path }

  it 'shows index of users worlds' do
    expect(page).to have_content(world.title)
    expect(page).not_to have_content(other_world.title)
    expect(page).to have_link(href: world_path(world))
    expect(page).not_to have_link('', href: world_path(other_world))
  end
end
