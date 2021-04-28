# frozen_string_literal: true

RSpec.shared_examples 'associated_with_world', type: :model do
  let(:subject_world) { subject.world }
  let(:klass)         { subject.class }
  let(:method)        { subject.model_name.plural.to_s.downcase.to_sym }
  let(:assoc_obj)     { subject.model_name.to_s.downcase.to_sym }
  let(:limit)         { 3 }

  context 'scope last_updated', :comprehensive do
    it 'selects 3 last modified items' do
      (limit + 1).times { create(assoc_obj, world: subject_world) }
      res = has_many.last_updated(limit)
      expect(res.count).to eq(limit)
      expect(res.first.updated_at).to be > res.last.updated_at
    end
  end

  context 'when deleting the world', :comprehensive do
    it 'all its items are destroyed too' do
      limit.times { create(assoc_obj, world: subject_world).save! }
      items = has_many.map(&:id)
      # expect(items.count).to eq limit
      world.save
      world.destroy!
      expect(klass.send(:find_by, id: items)).to be_nil
    end
  end

  def has_many
    subject_world.send(method)
  end
end
