# frozen_string_literal: true

RSpec.describe 'Image Attachment Tag Helper' do
  let(:world) { create(:world) }

  it 'creates the path to an attached image variant' do
    attach_file(world.image, 'earth.jpg')
    expect(helper.attached_img_path(world.image, 64, 64))
      .to match %r{^/rails/active_storage/representations/.+/earth.jpg$}
  end

  it 'returns nothing for non image attachments' do
    attach_file(world.image, 'file.pdf')
    expect(helper.attached_img_path(world.image)).to match /^$/
  end

  it 'returns nothing for invariable images' do
    attach_file(world.image, 'non-variable.png')
    expect { helper.attached_img_path(world.image) }
      .not_to raise_error
    expect(helper.attached_img_path(world.image)).to match /^$/
  end
end
