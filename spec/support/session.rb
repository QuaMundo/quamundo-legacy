RSpec.shared_context 'Session' do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  around(:example) do |example|
    sign_in user
    example.run
    sign_out user
  end
end
