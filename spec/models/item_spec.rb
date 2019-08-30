RSpec.describe Item, type: :model do
  include_context 'Session'

  let(:world) { build(:world) }

  it 'is invalid without a name' do
    an_item = build(:item, world: world, name: nil)
    expect(an_item).not_to be_valid
    expect { an_item.save!(validate: false) }
      .to raise_error ActiveRecord::NotNullViolation
  end

  it_behaves_like 'noteable' do
    let(:subject) { build(:item_with_notes) }
  end

  it_behaves_like 'inventory' do
    let(:subject) { build(:item, world: world) }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { build(:item, world: world) }
  end

  it_behaves_like 'tagable' do
    let(:subject) { build(:item_with_tags) }
  end

  it_behaves_like 'traitable' do
    let(:subject) { build(:item_with_traits) }
  end

  it_behaves_like 'dossierable' do
    let(:subject) { build(:item_with_dossiers) }
  end

  it_behaves_like 'updates parents' do
    let(:parent)  { create(:world) }
    let(:subject) { create(:item, world: parent) }
  end

  it_behaves_like 'relatable' do
    let(:subject) { build(:item, world: world) }
  end
end
