RSpec.shared_examples 'traitable', type: :model do
  let(:assoc_obj)   { subject.model_name.to_s.downcase.to_sym }

  it 'has a set of traits' do
    subject.save
    expect(subject.trait.attributeset).not_to be_nil
  end

  it 'deletes traits when subject is deleted' do
    obj = create(assoc_obj, world: world)
    trait_id = obj.trait.id
    obj.destroy!
    expect(Trait.find_by(id: trait_id)).to be_nil
  end

  it 'exists only once for every inventory item' do
    subject.save
    subject.create_trait(attributeset: { key_a: 'value a', key_b: 'value b' })
    subject.save
    expect(Trait.where('traitable_type = ? and traitable_id = ?',
           subject.model_name.to_s, subject.id).count)
      .to eq(1)
  end
end
