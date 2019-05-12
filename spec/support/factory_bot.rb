require 'support/quamundo_test_helpers'

RSpec.configure do |c|
  c.include FactoryBot::Syntax::Methods
end

FactoryBot::SyntaxRunner.class_eval do
  include QuamundoTestHelpers
end

