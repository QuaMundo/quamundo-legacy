RSpec.describe Figure, type: :model do
  include_context 'Session'

  let(:figure) { build(:figure, world: world) }

  it 'is not valid without name' do
    a_figure = world.figures.new
    expect(a_figure).not_to be_valid
    expect(a_figure.save).to be_falsey
  end

  it_behaves_like 'noteable' do
    let(:subject) { figure }
  end

  it_behaves_like 'inventory' do
    let(:subject) { figure }
  end

  it_behaves_like 'associated_with_world' do
    let(:subject) { figure }
  end

  it_behaves_like 'tagable' do
    let(:subject) { figure }
  end

  it_behaves_like 'updates parents' do
    let(:subject) { figure }
    let(:parent)  { figure.world }
  end
end
