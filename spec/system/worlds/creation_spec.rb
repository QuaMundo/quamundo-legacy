RSpec.describe 'Creating a world', type: :system, login: :user_with_worlds do
  include_context 'Session'

  before(:example) { visit new_world_path }

  it 'is successfull with completed form' do
    world_count = user_with_worlds.worlds.count
    fill_in('Title', with: 'One More new World')
    fill_in('Description', with: 'Description of newly created world')
    click_button('submit')
    expect(user_with_worlds.worlds.count).to eq(world_count + 1)
    expect(page).to have_content('One More new World')
  end

  it 'is successfully with completed form and image attached' do
    fill_in('Title', with: 'One More new World with image')
    page.attach_file('world_image', fixture_file_name('earth.jpg'))
    click_button('submit')
    expect(page).to have_selector('img.world-image')
  end

  it 'redirects to new form if title is missing' do
    click_button('submit')
    expect(page).to have_css('.alert', text: 'Title')
  end

  it_behaves_like 'valid_view' do
    let(:subject) { new_world_path }
  end
end
