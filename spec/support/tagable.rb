RSpec.shared_examples 'tagable', type: :model do
  let(:assoc_obj)     { subject.model_name.to_s.downcase.to_sym }

  it 'has a tagset' do
    subject.save
    expect(subject.tag.tagset).not_to be_nil
  end

  it 'deletes tagset when subject is deleted' do
    obj = create(assoc_obj, world: world)
    tag_id = obj.tag.id
    obj.destroy!
    expect(Tag.find_by(id: tag_id)).to be_nil
  end

  it 'exist only once for every inventory item' do
    subject.save
    subject.create_tag(tagset: ['new'])
    subject.save
    expect(Tag.where('tagable_type = ? and tagable_id = ?',
           subject.model_name.to_s, subject.id).count)
      .to eq(1)
  end
end
