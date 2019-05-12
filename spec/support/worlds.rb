RSpec.shared_context 'Worlds' do |context|
  include_context 'Users'

  let(:world) { user_with_worlds.worlds.first }
  let(:other_world) { other_user_with_worlds.worlds.first }
end
