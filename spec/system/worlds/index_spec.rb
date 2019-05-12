RSpec.describe 'Listing worlds', type: :system, login: :user_with_worlds do
  include_context 'Session'

  before(:example) { visit worlds_path }

  it 'shows index of users worlds' do
    expect(page).to have_content(world.title)
    expect(page).not_to have_content(other_world.title)
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
