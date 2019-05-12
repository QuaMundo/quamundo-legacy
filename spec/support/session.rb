RSpec.shared_context 'Session' do
  include Devise::Test::IntegrationHelpers

  # This shared context spawns a login session around an example
  # Choose tag login:
  # * :user               a user without any wolrds attached
  # * :user_with_worlds   a user with some worlds attached

  include_context 'Worlds'

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

  around(:example, login: :other_user_with_worlds) do |example|
    sign_in other_user_with_worlds
    example.run
    sign_out other_user_with_worlds
  end
end
