RSpec.shared_context 'Users' do |context|
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_with_worlds) { create(:user_with_worlds) }
  let(:other_user_with_worlds) { create(:user_with_worlds, worlds_count: 5) }
end
