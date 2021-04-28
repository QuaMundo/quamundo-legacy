# frozen_string_literal: true

RSpec.describe UserPolicy, type: :policy do
  context 'for normal user' do
    include_context 'Session'

    let(:context) { { user: user } }

    describe_rule :new? do
      failed 'if user is not admin'
    end

    describe_rule :index? do
      failed 'if user is not admin'
    end
  end

  context 'for admin user' do
    include_context 'Admin Session'

    let(:context) { { user: user } }

    describe_rule :new? do
      succeed 'if user is admin'
    end

    describe_rule :index? do
      succeed 'if user is admin'
    end
  end
end
