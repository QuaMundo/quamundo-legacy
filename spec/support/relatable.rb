# frozen_string_literal: true

RSpec.shared_examples 'relatable', type: :model do
  let(:fact)        { create(:fact, world: subject.world) }
  let(:relation)    { create(:relation_with_constituents, fact: fact) }
  let!(:fact_constituent) do
    fact.fact_constituents.create(constituable: subject)
  end
  let!(:relation_constituent) do
    relation.relation_constituents
            .create(fact_constituent: fact_constituent, role: :subject)
  end

  before(:example) do
    refresh_materialized_views(SubjectRelativeRelation)
  end

  context 'unidirectional' do
    it 'can have an associated relative' do
      expect(subject.relatives.map(&:relative))
        .to contain_exactly(*relation.relatives)
      expect(relation.relatives.first.relatives)
        .to be_empty
    end
  end

  context 'bidirectional' do
    before(:example) do
      relation.update(reverse_name: 'is related to by')
      refresh_materialized_views(SubjectRelativeRelation)
    end

    it 'can have an associated relative' do
      expect(subject.relatives.map(&:relative))
        .to contain_exactly(*relation.relatives)
      expect(relation.relatives.first.relatives.map(&:relative))
        .to contain_exactly(*relation.subjects)
    end

    it 'also is related to inventories' do
      relation.relatives.each do |relative|
        expect(relative.relatives.map(&:relative))
          .to include(relation_constituent)
      end
    end
  end
end
