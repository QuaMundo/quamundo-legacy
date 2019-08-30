RSpec.describe SubjectRelativeRelation, type: :model do
  let!(:relation)  { create(:relation_with_constituents) }
  let(:sub_rel) do
    refresh_materialized_views(SubjectRelativeRelation)
    relation.subject_relative_relations.first
  end
  let(:subject)   { sub_rel.subject }
  let(:relative)  { sub_rel.relative }

  it 'is a read-only model' do
    expect(sub_rel.readonly?).to be_truthy
  end

  it 'has a relation, a subject and a relative associated' do
    expect(sub_rel.relation).to eq(relation)
    expect(relation.subjects).to include(sub_rel.subject)
    expect(relation.relatives).to include(sub_rel.relative)
    expect(sub_rel.fact_constituent).to eq(sub_rel.relative.fact_constituent)
    expect(sub_rel.fact_constituent)
      .not_to eq(sub_rel.subject.fact_constituent)
  end

  it 'is destroyed when its fact is destroyed' do
    relation.fact.destroy
    expect(SubjectRelativeRelation.find_by(relation_id: relation.id))
      .to be_nil
  end

  it 'is destroyed when its relation is destroyed' do
    relation.destroy
    expect(SubjectRelativeRelation.find_by(relation_id: relation.id))
      .to be_nil
  end

  it 'is destroyed when its subject is destroyed' do
    subject.destroy
    refresh_materialized_views(SubjectRelativeRelation)
    expect(SubjectRelativeRelation.find_by(relation_id: relation.id,
                                           subject_id: subject.id))
      .to be_nil
  end

  it 'is destroyed when its inventory is destroyed' do
    relative.destroy
    expect(SubjectRelativeRelation.find_by(relation_id: relation.id,
                                           relative_id: relative.id))
  end
end
