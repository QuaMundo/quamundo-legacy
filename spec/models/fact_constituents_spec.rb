RSpec.describe FactConstituent, type: :model do
  include_context 'Session'

  let(:world)     { build(:world) }
  let(:fact)      { build(:fact, world: world) }
  let(:item)      { build(:item, world: world) }
  let(:figure)    { build(:figure, world: world) }
  let(:location)  { build(:location, world: world) }
  # let(:spirits)   { 2.times { build(:spirit, world: world) } }

  let!(:item_fc)   {
    create(:fact_constituent,
           fact: fact,
           constituable: item,
           roles: ['n.n.', 'superduper'])
  }
  let!(:figure_fc) {
    create(:fact_constituent,
           fact: fact,
           constituable: figure,
           roles: ['n.n.', 'superduper'])
  }
  let!(:location_fc) {
    create(:fact_constituent,
           fact: fact,
           constituable: location,
           roles: ['n.n.', 'superduper'])
  }

  it 'can be build with item, figure and location' do
    expect(fact.fact_constituents.count).to eq(3)
    expect(fact.fact_constituents.map(&:constituable))
      .to contain_exactly(item, figure, location)
    expect(fact.items).to include(item)
    expect(fact.figures).to include(figure)
    expect(fact.locations).to include(location)
    expect(item.facts).to include(fact)
    expect(figure.facts).to include(fact)
    expect(location.facts).to include(fact)
  end

  it 'has an empty list of roles if no roles are given' do
    fc = create(:fact_constituent, fact: fact, constituable: build(:item))
    expect(fc.roles).to be_empty
  end

  it 'is destroyed when fact gets destroyed' do
    fact.save
    fact.destroy
    expect(FactConstituent.all).not_to include(item_fc, figure_fc, location_fc)
  end

  it 'is destroyed when inventory is destroyed' do
    [item, figure, location].each(&:destroy)
    expect(fact.fact_constituents.count).to eq(0)
  end

  it 'refuses to store duplicate constituents' do
    fc = fact.fact_constituents.build(constituable: item)
    expect(fc).not_to be_valid
    expect { fc.save!(validate: false) }
      .to raise_error ActiveRecord::RecordNotUnique
  end

  it 'refuses to add another fact as constituable' do
    other_fact = create(:fact, world: world)
    fc = fact.fact_constituents.build(constituable: other_fact)
    expect(fc).not_to be_valid
  end

  it 'refuses creation if no constituable is given' do
    fc = fact.fact_constituents.build()
    expect(fc).not_to be_valid
    expect { fc.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
  end

  it 'touches timestamp of its fact when added' do
    t = fact.updated_at
    travel(10.days) do
      fact.fact_constituents << create(
        :fact_constituent,
        fact: fact,
        constituable: build(:item))
      expect(fact.updated_at).to be > t
    end
  end

  it 'touches timestamp of its fact when updated' do
    t = fact.updated_at
    travel(10.days) do
      fact.fact_constituents.first.update(roles: ['a', 'b', 'c'])
      expect(fact.updated_at).to be > t
    end
  end

  it 'refuses to change constituable'

  it 'removes roles when updating with empty array' do
    item_fc.roles = nil
    item_fc.save
    item_fc.reload
    expect(item_fc.roles).to be_empty
  end
end
