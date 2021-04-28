# frozen_string_literal: true

RSpec.describe 'Deleting a world', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }

  before(:example) { visit(world_path(world)) }

  it 'brings apocalypse', :js, :comprehensive do
    world.reload
    page.find('.nav-item a.nav-link.dropdown').click
    page.accept_confirm do
      page.first('a.dropdown-item[title="delete"]').click
    end
    expect(page).to have_current_path(worlds_path)
    expect(World.find_by(id: world.id)).to be_falsey
  end

  it_behaves_like 'valid_view' do
    let(:subject) { world_path(world) }
  end
end
