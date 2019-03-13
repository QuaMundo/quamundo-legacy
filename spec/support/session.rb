RSpec.shared_context 'Session' do
  include Devise::Test::IntegrationHelpers

  # This shared context spawns a login session around an example
  # Choose tag login:
  # * :user               a user without any wolrds attached
  # * :user_with_worlds   a user with some worlds attached

  include_context 'Users'
  include_context 'Worlds'

  # FIXME Can this be more DRY
  around(:example, login: :user) do |example|
    sign_in user
    example.run
    sign_out user
  end

  around(:example, login: :user_with_worlds) do |example|
    sign_in user_with_worlds
    example.run
    sign_out user_with_worlds
  end
end
