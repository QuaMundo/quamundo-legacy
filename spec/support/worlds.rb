RSpec.shared_context 'Worlds' do |context|
  include ActiveSupport::Testing::TimeHelpers
    
  let(:world) { create(:world) }

  # create some inventory to fill up worlds
  def create_some_inventory(user)
    user.worlds.each do |world|
      3.times do
        travel(rand 21) { world.items << create(:item) }
        travel(rand 21) { world.figures << create(:figure) }
      end
    end
  end

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
