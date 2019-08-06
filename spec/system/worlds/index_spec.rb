RSpec.describe 'Listing worlds', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }
  let(:other_world) { create(:world) }

  before(:example) do
    # Call the worlds to force creation
    # FIXME: ^^optimize this issue
    world.save
    other_world.save

    visit worlds_path
  end

  it 'shows index of users worlds' do
    expect(World.all).to include(world)
    expect(page).to have_content(world.name)
    expect(page).not_to have_content(other_world.name)
    expect(page).to have_link(href: world_path(world))
    expect(page).not_to have_link('', href: world_path(other_world))
  end

  it 'shows index context menu' do
    page.first('.card-header') do
      expect(page).to have_link(href: new_world_path)
    end
  end

  it_behaves_like 'valid_view' do
    let(:subject) { worlds_path }
  end
end
