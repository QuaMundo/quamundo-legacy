RSpec.describe 'Image Attachment Tag Helper' do
  include_context 'Users'
  let(:world)   { user_with_worlds.worlds.first }

  it 'creates the path to an attached image variant' do
    attach_file(world.image, 'earth.jpg')
    expect(helper.attached_img_path(world.image, resize: "64x64"))
      .to match %r(^/rails/active_storage/representations/.+/earth.jpg$)
  end

  it 'returns nothing for non image attachments' do
    attach_file(world.image, 'file.pdf')
    expect(helper.attached_img_path(world.image)).to match /^$/
  end
end
