RSpec.describe Item, type: :model do
  include_context 'Session'

  let(:item) { build(:item, world: world) }

  it 'is invalid without a name' do
    an_item = world.items.new
    expect(an_item).not_to be_valid
    expect { an_item.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
  end

  it_behaves_like 'noteable' do
    let(:subject) { item }
  end

  it_behaves_like 'inventory' do
    let(:subject) { item }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { item }
  end

  it_behaves_like 'tagable' do
    let(:subject) { item }
  end

  it_behaves_like 'updates parents' do
    let(:subject) { item }
    let(:parent)  { item.world }
  end
end
