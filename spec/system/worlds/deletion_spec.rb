RSpec.describe 'Deleting a world', type: :system, login: :user_with_worlds do
  include_context 'Session'

  let(:world) { user_with_worlds.worlds.last }

  before(:example) { visit(world_path(world)) }

  it 'brings apocalypse', :js, :comprehensive do
    # FIXME: This fails with geckodriver!?
    page.accept_confirm() do
      page.find('nav.context-menu a.nav-link[title="delete"]').click
    end
    expect(current_path).to eq(worlds_path)
    expect(World.find_by(id: world.id)).to be_falsey
  end
end
