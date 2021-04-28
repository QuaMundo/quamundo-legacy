# frozen_string_literal: true

RSpec.describe 'Element ID helper', type: :helper do
  let(:world)   { build(:world, id: 42) }
  let(:user)    { build(:user, id: 111_268) }
  let(:prefix)  { 'prefix' }

  context 'for user' do
    it 'creates an user id' do
      expect(helper.element_id(user))
        .to eq("user-#{user.id}")
    end

    it 'creates an user id with prefix' do
      expect(helper.element_id(user, prefix))
        .to eq("#{prefix}-user-#{user.id}")
    end
  end

  context 'for world' do
    it 'creates an world id' do
      expect(helper.element_id(world))
        .to eq("world-#{world.id}")
    end

    it 'creates an world id with prefix' do
      expect(helper.element_id(world, prefix))
        .to eq("#{prefix}-world-#{world.id}")
    end
  end
end
