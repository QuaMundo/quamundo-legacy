RSpec.describe 'Updating/editing a world', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }

  before(:example) { visit edit_world_path(world) }

  it 'description can be changed' do
    expect(page).to have_selector("img##{element_id(world, 'img')}")
    fill_in('Description', with: 'A new description')
    click_button('submit')
    expect(page).to be_i18n_ready
    expect(page).to have_current_path(world_path(world))
    expect(page).to have_content('A new description')
  end

  it 'refuses to change title' do
    expect(page)
      .to have_selector('input[type="text"][name="world[title]"][disabled]')
  end

  it 'attaches an image' do
    page.attach_file('world_image', fixture_file_name('earth.jpg'))
    click_button('submit')
    expect(page).to be_i18n_ready
    expect(page).to have_current_path(world_path(world))
    expect(world.image).to be_attached
    expect(page).to have_selector('img.world-image')
  end

  it 'refuse to attach non image files' do
    page.attach_file('world_image', fixture_file_name('file.pdf'))
    click_button('submit')
    expect(page).to be_i18n_ready
    expect(page).to have_current_path(world_path(world))
    expect(world.image.filename).not_to eq('file.pdf')
    pending("First find out how errors and flash work")
    expect(page).to have_selector('.alert', text: 'Only images may be')
  end

  it_behaves_like 'valid_view' do
    let(:subject) { edit_world_path(world) }
  end
end
