# frozen_string_literal: true

RSpec.describe 'Updating/editing a world', type: :system do
  include_context 'Session'

  let(:world) { create(:world, user: user) }

  it 'description can be changed' do
    visit edit_world_path(world)
    expect(page).to have_selector("img##{element_id(world, 'img')}")
    fill_in('Description', with: 'A new description')
    click_button('submit')
    expect(page).to have_current_path(world_path(world))
    expect(page).to have_content('A new description')
  end

  it 'refuses to change name' do
    visit edit_world_path(world)
    expect(page)
      .to have_selector('input[type="text"][name="world[name]"][disabled]')
  end

  it 'attaches an image' do
    visit edit_world_path(world)
    page.attach_file('world_image', fixture_file_name('earth.jpg'))
    click_button('submit')
    expect(page).to have_current_path(world_path(world))
    expect(world.image).to be_attached
    expect(page).to have_selector('img.world-image')
  end

  it 'refuse to attach non image files' do
    visit edit_world_path(world)
    page.attach_file('world_image', fixture_file_name('file.pdf'))
    click_button('submit')
    expect(page).to have_current_path(world_path(world))
    expect(world.image.filename).not_to eq('file.pdf')
    expect(page).to have_selector('.alert', text: /^Failed to update/)
  end

  it 'lets enter tags' do
    visit edit_world_path(world)
    page.find('input[id$="_tag_attributes_tagset"]')
        .fill_in(with: 'tag 1, tag 2, tag 3')
    click_button('submit')
    within('.tagset') do
      ['tag 1', 'tag 2', 'tag 3'].each do |tag|
        expect(page).to have_selector('.tag', text: tag)
      end
    end
  end

  it_behaves_like 'valid_view' do
    let(:subject) { edit_world_path(world) }
  end

  it_behaves_like 'editable traits' do
    let(:subject) { create(:world, :with_traits, user: user) }
  end
end
