require 'support/active_storage_helper'

RSpec.configure do |c|
  c.include FactoryBot::Syntax::Methods
end

FactoryBot::SyntaxRunner.class_eval do
  include ActiveStorageTestHelpers
end

