require 'support/quamundo_test_helpers'
require 'support/factorybot_common_traits'

RSpec.configure do |c|
  c.include FactoryBot::Syntax::Methods
end

FactoryBot::SyntaxRunner.class_eval do
  include QuamundoTestHelpers
end

