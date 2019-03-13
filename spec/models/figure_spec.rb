RSpec.describe Figure, type: :model do
  include_context 'Session'
  include_context 'Users'

  let(:world) { user_with_worlds.worlds.first }
  let(:figure) { build(:figure, world: world) }

  it 'can only be created in a world' do
    expect(figure).to be_valid
    expect(figure.world).to eq(world)
    expect(Figure.new(nick: 'bla')).not_to be_valid
  end

  it 'is indirectly linked to a user' do
    figure.save
    expect(user_with_worlds.figures).to include(figure)
    expect(figure.user).to eq(user_with_worlds)
  end

  it 'has a unique nick' do
    figure.save
    other_figure = build(:figure, world: world, nick: figure.nick.upcase)
    expect(other_figure).not_to be_valid
    expect { other_figure.save!(validate: false) }
      .to raise_error ActiveRecord::RecordNotUnique
  end

  it 'can get an image attached' do
    attach_file(figure.image, 'figure.png')
    figure.save!
    expect(figure.image).to be_attached
  end

  it_behaves_like "associated_with_world" do
    let(:subject) { figure }
  end

  # FIXME: Refactor next examples to use shaerd examples
  it 'changes nick to all lower case' do
    new_figure = build(:figure, nick: 'aBcDe')
    new_figure.save!
    expect(new_figure.nick).to eq('abcde')
  end

  it 'only allows a-zA-Z0-9 and .-_ chars in nick' do
    figure.nick = '.ali'
    expect(figure).to be_invalid
    figure.nick = 'hallo & welt'
    expect(figure).to be_invalid
    figure.nick = 'hallo_1-welt.neu'
    expect(figure).to be_valid
  end
end
