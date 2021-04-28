# frozen_string_literal: true

RSpec.describe Trait, type: :model do
  # let(:world) { build(:world) }
  let(:trait) { build(:trait, attributeset: {}, traitable: nil) }

  it 'has an empty hash after creation' do
    expect(trait.attributeset).to eq({})
  end

  it 'can store key-value pairs' do
    trait.attributeset = { a: 42, b: 'ali' }
    expect(trait.attributeset['a']).to eq('42')
    expect(trait.attributeset['b']).to eq('ali')
  end

  it 'has unique keys' do
    trait.attributeset = { a: 43, b: 44, 'a' => 42 }
    trait.validate
    expect(trait.attributeset).to eq({ 'a' => '42', 'b' => '44' })
  end
end
