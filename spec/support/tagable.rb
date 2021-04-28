# frozen_string_literal: true

RSpec.shared_examples 'tagable', type: :model do
  before(:example) { subject.save! }

  it 'has a tagset' do
    expect(subject.tag.tagset).not_to be_nil
  end

  it 'deletes tagset when subject is deleted' do
    tag_id = subject.tag.id
    subject.destroy!
    expect(Tag.find_by(id: tag_id)).to be_nil
  end

  it 'exist only once for every inventory item' do
    subject.create_tag(tagset: ['new'])
    subject.save
    expect(Tag.where('tagable_type = ? and tagable_id = ?',
                     subject.model_name.to_s, subject.id).count)
      .to eq(1)
  end
end
