RSpec.describe 'Updating/editing a world',
  type: :system, login: :user_with_worlds do

  include_context 'Session'
  include_context 'Worlds'

  let(:world) { user_with_worlds.worlds.first }

  before(:example) { visit edit_world_path(world) }

  it 'description can be changed' do
    fill_in('Description', with: 'A new description')
    click_button('submit')
    expect(current_path).to eq(world_path(world))
    expect(page).to have_content('A new description')
  end

  it 'refuses to change title' do
    expect(page)
      .to have_selector('input[type="text"][name="world[title]"][disabled]')
  end

  it 'attaches an image' do
    page.attach_file('world_image', fixture_file_name('earth.jpg'))
    click_button('submit')
    expect(current_path).to eq(world_path(world))
    expect(world.image).to be_attached
    expect(page).to have_selector('img.world-image')
  end

  it 'refuse to attach non image files' do
    page.attach_file('world_image', fixture_file_name('file.pdf'))
    click_button('submit')
    expect(current_path).to eq(world_path(world))
    expect(world.image.filename).not_to eq('file.pdf')
    pending("First find out how errors and flash work")
    expect(page).to have_selector('.alert', text: 'Only images may be')
  end

  xit 'removes old images and variants after update' do
    old_key = world.image.key
    image_paths = generate_some_image_paths(world)
    page.attach_file('world_image', fixture_file_name('htrae.jpg'))
    click_button('submit')
    expect(world.reload.image.key).not_to eq(old_key)
    #expect(image_paths.none? { |f| File.exist? f }).to be_truthy
    image_paths.each do |p|
      expect(File.exist? p).to be_falsey
    end
  end

  it_behaves_like 'valid_view' do
    let(:subject) { edit_world_path(world) }
  end
end
