# frozen_string_literal: true

RSpec.describe RegistrationPolicy, type: :policy do
  context 'for normal user' do
    include_context 'Session'

    let(:context)   { { user: user } }

    describe_rule :create? do
      failed 'if user is not admin'
    end

    describe_rule :edit? do
      succeed 'for normal user'
    end

    describe_rule :update? do
      succeed 'for normal user'
    end

    describe_rule :destroy? do
      succeed 'for normal user'
    end

    describe_rule :cancel? do
      succeed 'for normal user'
    end
  end

  context 'for admin user' do
    include_context 'Admin Session'

    let(:context)   { { user: user } }

    describe_rule :create? do
      succeed 'if user is admin'
    end

    describe_rule :edit? do
      succeed 'if user is admin'
    end

    describe_rule :update? do
      succeed 'if user is admin'
    end

    describe_rule :destroy? do
      failed 'if user is admin'
    end

    describe_rule :cancel? do
      succeed 'if user is admin'
    end
  end
end
