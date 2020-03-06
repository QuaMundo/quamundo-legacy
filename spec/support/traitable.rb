RSpec.shared_examples 'traitable', type: :model do
  before(:example) { subject.save }
  it 'has a set of traits' do
    expect(subject.trait.attributeset).not_to be_nil
  end

  it 'deletes traits when subject is deleted' do
    trait_id = subject.trait.id
    subject.destroy!
    expect(Trait.find_by(id: trait_id)).to be_nil
  end

  it 'exists only once for every inventory item' do
    subject.create_trait(attributeset: { key_a: 'value a', key_b: 'value b' })
    subject.save
    expect(Trait.where('traitable_type = ? and traitable_id = ?',
           subject.model_name.to_s, subject.id).count)
      .to eq(1)
  end
end
