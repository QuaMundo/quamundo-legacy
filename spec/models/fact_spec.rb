RSpec.describe Fact, type: :model do
  include_context 'Session'

  let(:world) { build(:world) }

  it 'is invalid without a name' do
    a_fact = build(:fact, world: world, name: nil)
    expect(a_fact).not_to be_valid
    expect { a_fact.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
  end

  context 'start and end dates' do
    it 'can have a start date' do
      fact = build(:fact, world: world, start_date: DateTime.current)
      expect(fact).to be_valid
    end

    it 'can have an end date' do
      fact = build(:fact, world: world, end_date: DateTime.current + 2.days)
      expect(fact).to be_valid
    end

    it 'can have a start and end date if end is after start' do
      fact = build(:fact, world: world,
                   start_date: DateTime.current - 1.day,
                   end_date: DateTime.current + 1.day)
      expect(fact).to be_valid
    end

    it 'cannot have a start date that is behind end date' do
      fact = build(:fact, world: world,
                   start_date: DateTime.current + 1.day,
                   end_date: DateTime.current - 1.day)
      expect(fact).not_to be_valid
    end
  end

  it_behaves_like 'noteable' do
    let(:subject) { build(:fact, world: world) }
  end

  it_behaves_like 'inventory' do
    let(:subject) { build(:fact, world: world) }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { build(:fact, world: world) }
  end

  it_behaves_like 'tagable' do
    let(:subject) { build(:fact, world: world) }
  end

  it_behaves_like 'traitable' do
    let(:subject) { build(:fact, world: world) }
  end

  it_behaves_like 'dossierable' do
    let(:subject) { build(:fact, world: world) }
  end

  it_behaves_like 'updates parents' do
    let(:parent)  { create(:world) }
    let(:subject) { create(:fact, world: parent) }
  end
end
