RSpec.shared_context 'Worlds' do |context|
  let(:world) { create(:world) }

  protected
  def variant(world, resize_factor)
    world.image.variant(resize: resize_factor).processed.key
  end

  def active_storage_path(active_storage_key)
    ActiveStorage::Blob.service.send(:path_for, active_storage_key)
  end

  def generate_some_image_paths(world)
    sizes = %w(10x10 20x20 30x30)
    [active_storage_path(world.image.key)]
      .concat(sizes.map { |s| active_storage_path(variant(world, s)) })
  end
end
