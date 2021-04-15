# frozen_string_literal: true

# FIXME: Add `admin` flag in future versions!
RSpec.shared_context 'Admin Session' do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, id: 0) }

  around(:example) do |example|
    sign_in user
    example.run
    sign_out user
  end
end
