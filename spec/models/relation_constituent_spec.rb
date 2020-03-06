RSpec.describe RelationConstituent, type: :model do
  include_context 'Session'

  let(:fact)                { build(:fact, user: user) }

  context 'basic usage' do
    let(:relation)          { create(:relation, fact: fact) }
    let(:fact_constituent)  {
      build(:fact_constituent,
            fact: fact,
            constituable: build(:item, world: fact.world))
    }

    it 'can be created with a relation and a fact_constituent as subject' do
      rc = relation.relation_constituents
        .new(fact_constituent: fact_constituent,
             role: :subject)
      expect(rc).to be_valid
      expect(rc.fact).to eq(fact)
      # Trust the framwork ;)
      # expect { rc.save(validate: false) }
      #   .not_to raise_error
    end

    it 'can be created with a relation and a fact_constituent as relative' do
      rc = relation.relation_constituents
        .new(fact_constituent: fact_constituent,
             role: :relative)
      expect(rc).to be_valid
      expect { rc.save!(validate: false) }
        .not_to raise_error
    end

    it 'is invalid without a role' do
      rc = RelationConstituent.new(relation: relation,
                                   fact_constituent: fact_constituent)
      expect(rc).not_to be_valid
      expect { rc.save!(validate: false) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'is invalid without a relation' do
      rc = RelationConstituent.new(fact_constituent: fact_constituent,
                                   role: :subject)
      expect { rc.save!(validate: false) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'is invalid without a fact_constituent' do
      rc = RelationConstituent.new(relation: relation,
                                   role: :relative)
      expect { rc.save!(validate: false) }
        .to raise_error ActiveRecord::NotNullViolation
    end

    it 'cannot change its fact_constituent' do
      other_fc = build_stubbed(:fact_constituent,
                        fact: build(:fact, world: fact.world),
                        constituable: build(:item, world: fact.world))
      rc = relation.relation_constituents
        .create(fact_constituent: fact_constituent,
                role: :subject)
      rc.fact_constituent = other_fc
      # DB exception not thrown since attribute is read-only in rails!
      # expect { rc.save!(validate: false) }
      #   .to raise_error
      rc.save
      rc.reload
      expect(rc.fact_constituent).to eq(fact_constituent)
    end

    it 'cannot change its relation' do
      other_relation = build_stubbed(:relation, fact: fact)
      rc = relation.relation_constituents
        .create(fact_constituent: fact_constituent,
                role: :subject)
      rc.relation = other_relation
      # DB exception not thrown since attribute is read-only in rails!
      # expect { rc.save!(validate: false) }
      #   .to raise_error
      rc.save
      rc.reload
      expect(rc.relation).to eq(relation)
    end

    it 'cannot build with a constituent of another fact' do
      other_fact = build(:fact_with_constituents)
      expect { relation.relation_constituents
        .create!(fact_constituent: other_fact.fact_constituents.first,
                 role: :subject)
      }.to raise_error ActiveRecord::RecordInvalid
      rc = build(:relation_constituent,
                 relation: relation,
                 fact_constituent: other_fact.fact_constituents.first,
                 role: :subject)
      expect(rc).not_to be_valid
    end

    it 'refuses to add constituent more than once' do
      relation.relation_constituents
        .create(fact_constituent: fact_constituent,
                role: :subject)
      rc = relation.relation_constituents
        .build(fact_constituent: fact_constituent,
               role: :subject)
      expect(rc).not_to be_valid
      expect { rc.save!(validate: false) }
        .to raise_error ActiveRecord::RecordNotUnique
    end

    it 'is destroyed if its relation gets destroyed' do
      rc = relation
        .relation_constituents.create(fact_constituent: fact_constituent,
                                      role: :subject)
      relation.destroy
      expect { rc.reload }.to raise_error ActiveRecord::RecordNotFound
      expect(SubjectRelativeRelation.find_by(relation_id: relation.id))
        .to be_nil
    end

    it 'is destroyed if its fact_constituent is destroyed' do
      rc = relation
        .relation_constituents.create(fact_constituent: fact_constituent,
                                      role: :subject)
      fact_constituent.destroy
      expect { rc.reload }.to raise_error ActiveRecord::RecordNotFound
      expect(SubjectRelativeRelation.find_by(subject_id: fact_constituent.id))
        .to be_nil
      expect(SubjectRelativeRelation.find_by(relative_id: fact_constituent.id))
        .to be_nil
    end
  end

  # FIXME: Are those really redundant?
  # context 'advanced usage' do
  #   let(:relation)      { create(:relation_with_constituents, fact: fact) }
  #   let(:subject)       { relation.subjects.first.relation_constituent }
  #   let(:relative)      { relation.relatives.first.relation_constituent }

  #   context 'unidirectional' do
  #     it 'has a subject with associated subject relative relations'
  #   end



  #   context 'bidirectional' do
  #     before(:example)  { relation.update(reverse_name: 'is related to by') }

  #     it 'has also relatives with associated subject relative relations'
  #   end
  # end
end
