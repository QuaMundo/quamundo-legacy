RSpec.shared_examples "associated_with_world", type: :model do

  let(:subject_world) { subject.world }
  let(:klass)         { subject.class }
  let(:method)        { subject.model_name.plural.to_s.downcase.to_sym }
  let(:assoc_obj)     { subject.model_name.to_s.downcase.to_sym }
  let(:has_many)      { subject_world.send(method) }
  let(:limit)         { 3 }

  # FIXME: Right placed here?
  context 'scope last_updated', :comprehensive do
    it 'selects 3 last modified items' do
      (limit + 1).times { create(assoc_obj, world: subject_world) }
      res = has_many.last_updated(limit)
      expect(res.count).to eq(limit)
      expect(res.first.updated_at).to be > res.last.updated_at
    end
  end

  context 'when updating worlds items', :comprehensive do
    it 'world "updated_at" follows its items updates' do
      world_updated_at = subject_world.updated_at
      subject.save!
      expect(subject_world.updated_at).to be > world_updated_at
      expect(subject_world.updated_at.to_f)
        .to be_within(subject.updated_at.to_f).of(0.5)
    end
  end

  context 'when deleting the world', :comprehensive do
    it 'all its items are destroyed too' do
      items = has_many.each.map(&:id)
      world.destroy!
      expect(klass.send(:find_by, id: items)).to be_nil
    end
  end
end
