RSpec.describe 'Creating a world', type: :system do
  include_context 'Session'

  let(:user) { create(:user_with_worlds) }

  before(:example) { visit new_world_path }

  it 'is successfull with completed form' do
    world_count = user.worlds.count
    fill_in('Name', with: 'One More new World')
    fill_in('Description', with: 'Description of newly created world')
    click_button('submit')
    expect(user.worlds.count).to eq(world_count + 1)
    expect(page).to have_content('One More new World')
  end

  it 'is successfully with completed form and image attached' do
    fill_in('Name', with: 'One More new World with image')
    page.attach_file('world_image', fixture_file_name('earth.jpg'))
    click_button('submit')
    expect(page).to have_selector('img.world-image')
  end

  it 'redirects to new form if name is missing' do
    click_button('submit')
    expect(page).to have_css('.alert', text: /failed to create/i)
  end

  it_behaves_like 'valid_view' do
    let(:subject) { new_world_path }
  end
end
