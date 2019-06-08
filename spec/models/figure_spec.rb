RSpec.describe Figure, type: :model do
  include_context 'Session'

  let(:world) { build(:world) }

  it 'is not valid without name' do
    a_figure = build(:figure, name: nil, world: world)
    expect(a_figure).not_to be_valid
    expect(a_figure.save).to be_falsey
  end

  it_behaves_like 'noteable' do
    let(:subject) { build(:figure_with_notes) }
  end

  it_behaves_like 'inventory' do
    let(:subject) { build(:figure, world: world) }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { build(:figure, world: world) }
  end

  it_behaves_like 'tagable' do
    let(:subject) { build(:figure_with_tags) }
  end

  it_behaves_like 'traitable' do
    let(:subject) { build(:figure_with_traits) }
  end

  it_behaves_like 'dossierable' do
    let(:subject) { build(:figure_with_dossiers) }
  end

  it_behaves_like 'updates parents' do
    let(:parent)  { create(:world) }
    let(:subject) { create(:figure, world: parent) }
  end
end
