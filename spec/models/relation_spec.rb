RSpec.describe Relation, type: :model do
  include_context 'Session'

  let(:fact)      { create(:fact, user: user) }

  context 'basic usage' do
    let(:relation)  { create(:relation, fact: fact) }

    it 'can be created with a name' do
      rel = Relation.new(name: 'relates to', fact: fact)
      expect(rel).to be_valid
      expect { rel.save!(validate: false) }
        .not_to raise_error
    end

    it 'is invalid without a name' do
      rel = Relation.new(name: nil, fact: fact)
      expect(rel).not_to be_valid
      expect { rel.save!(validate: false) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'is invalid without a fact' do
      rel = Relation.new
      expect(rel).not_to be_valid
      expect { rel.save!(validate: false) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'has an associated fact' do
      expect(relation.fact).to eq(fact)
      expect(fact.relations).to include(relation)
    end

    it 'can add constituents' do
      inventory = build(:item, world: fact.world)
      fact_constituent = fact.fact_constituents
        .build(constituable: inventory)
      relation_constituent = relation.relation_constituents
        .build(fact_constituent: fact_constituent, role: :subject)
      expect(relation.relation_constituents)
        .to contain_exactly(relation_constituent)
    end

    it 'is unidirectional with only a name' do
      rel = Relation.new(name: 'relates to', fact: fact)
      expect(rel).to be_unidirectional
    end

    it 'is bidirectional with a name and a reverse_name' do
      rel = Relation.new(name: 'relates to',
                         reverse_name: 'is related to by',
                         fact: fact)
      expect(rel).to be_bidirectional
    end

    it 'gets destroyed if its fact is destroyed' do
      rel = create(:relation, fact: fact)
      fact.destroy
      expect { rel.reload}.to raise_error ActiveRecord::RecordNotFound
    end

    it 'cannot change its fact' do
      rel = create(:relation, fact: fact)
      other_fact = build(:fact, world: fact.world)
      rel.fact = other_fact
      # DB exception not thrown since attribute is read-only in rails!
      # expect { rel.save!(validate: false) }
      #   .to raise_error
      rel.save
      rel.reload
      expect(rel.fact).to eq(fact)
    end

    it_behaves_like 'updates parents' do
      let(:subject) { relation }
      let(:parent)  { fact }
    end
  end

  context 'advanced usage' do
    let(:fact)          { create(:fact, user: user) }
    let(:relation)      { create(:relation_with_constituents, fact: fact) }
    let(:subject_1)     { relation.subjects.first }
    let(:subject_2)     { relation.subjects.second }
    let(:relative_1)    { relation.relatives.first }
    let(:relative_2)    { relation.relatives.second }

    it 'knows about its subjects and relatives', db_triggers: true do
      #binding.pry
      expect(subject_2.class).to eq(RelationConstituent)
      expect(relation.subjects)
        .to contain_exactly(subject_1, subject_2)
      expect(relation.relatives)
        .to contain_exactly(relative_1, relative_2)
    end

    context 'unidirectional', db_triggers: true do
      it 'it associates its subjects to its relatives' do
        relatives = subject_1.relatives
        expect(subject_1.relatives.map(&:relative))
          .to contain_exactly(relative_1, relative_2)
        expect(relative_1.relatives).to be_empty
        fact_constituent = subject_1.fact_constituent
        expect(fact_constituent.relatives.map(&:relative))
          .to contain_exactly(relative_1, relative_2)
        inventory = fact_constituent.constituable
        expect(inventory.relatives.map(&:relative))
          .to contain_exactly(relative_1, relative_2)
      end
    end

    context 'bidirectional', db_triggers: true do
      before(:example)  { relation.update(reverse_name: 'is related to by') }

      it 'it associates its subjects to its relatives' do
        relatives = subject_1.relatives
        expect(subject_1.relatives.map(&:relative))
          .to contain_exactly(relative_1, relative_2)
        expect(relative_1.relatives.map(&:relative))
          .to contain_exactly(subject_1, subject_2)
        fact_constituent = subject_1.fact_constituent
        expect(fact_constituent.relatives.map(&:relative))
          .to contain_exactly(relative_1, relative_2)
        inventory = fact_constituent.constituable
        expect(inventory.relatives.map(&:relative))
          .to contain_exactly(relative_1, relative_2)
      end

      it 'it also associates its relatives to its subjects' do
        relatives = relative_1.relatives
        expect(relative_1.relatives.map(&:relative))
          .to contain_exactly(subject_1, subject_2)
        expect(subject_1.relatives.map(&:relative))
          .to contain_exactly(relative_1, relative_2)
        fact_constituent = relative_1.fact_constituent
        expect(fact_constituent.relatives.map(&:relative))
          .to contain_exactly(subject_1, subject_2)
        inventory = fact_constituent.constituable
        expect(inventory.relatives.map(&:relative))
          .to contain_exactly(subject_1, subject_2)
      end
    end
  end
end
