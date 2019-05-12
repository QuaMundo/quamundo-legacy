RSpec.describe 'Deleting a world', type: :system, login: :user_with_worlds do
  include_context 'Session'

  before(:example) { visit(world_path(world)) }

  it 'brings apocalypse', :js, :comprehensive do
    # FIXME: This fails with geckodriver!?
    page.accept_confirm() do
      page.first('nav.context-menu a.nav-link[title="delete"]').click
    end
    expect(page).to have_current_path(worlds_path)
    expect(World.find_by(id: world.id)).to be_falsey
  end

  it_behaves_like 'valid_view' do
    let(:subject) { world_path(world) }
  end
end
