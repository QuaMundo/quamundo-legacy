RSpec.describe 'Deleting a world', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }

  before(:example) { visit(world_path(world)) }

  it 'brings apocalypse', :js, :comprehensive do
    world.reload
    # FIXME: This fails with geckodriver!?
    page.accept_confirm() do
      page.first('nav.context-menu a.nav-link[title="delete"]').click
    end
    expect(page).to have_current_path(worlds_path)
    expect(World.find_by(id: world.id)).to be_falsey
    expect(page).to be_i18n_ready
  end

  it_behaves_like 'valid_view' do
    let(:subject) { world_path(world) }
  end
end
