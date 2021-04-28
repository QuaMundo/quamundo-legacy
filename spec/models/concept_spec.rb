# frozen_string_literal: true

RSpec.describe Concept, type: :model do
  include_context 'Session'

  let(:world) { build(:world) }

  it 'is invalid without a name' do
    a_concept = build(:concept, world: world, name: nil)
    expect(a_concept).not_to be_valid
    expect { a_concept.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
  end

  it_behaves_like 'noteable' do
    let(:subject) { build(:concept_with_notes) }
  end

  it_behaves_like 'inventory' do
    let(:subject) { build(:concept, world: world) }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { build(:concept, world: world) }
  end

  it_behaves_like 'tagable' do
    let(:subject) { build(:concept) }
  end

  it_behaves_like 'traitable' do
    let(:subject) { build(:concept) }
  end

  it_behaves_like 'dossierable' do
    let(:subject) { build(:concept_with_dossiers) }
  end

  it_behaves_like 'updates parents' do
    let(:parent)  { create(:world) }
    let(:subject) { create(:concept, world: parent) }
  end

  it_behaves_like 'relatable' do
    let(:subject) { build(:concept, world: world) }
  end
end
