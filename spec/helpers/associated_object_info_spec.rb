RSpec.describe 'Associated object info', type: :helper do
  it 'shows world title' do
    world = build(:world, title: 'Hello World')
    expect(helper.associated_object_info(world))
      .to eq("World \"Hello World\"")
  end

  it 'shows figure name' do
    fig = build(:figure, name: 'John')
    expect(helper.associated_object_info(fig))
      .to eq('Figure "John"')
  end

  it 'shows item name' do
    fig = build(:item, name: 'Thingie')
    expect(helper.associated_object_info(fig))
      .to eq('Item "Thingie"')
  end

  it 'shows location name' do
    loc = build(:location, name: 'Somewhere')
    expect(helper.associated_object_info(loc))
      .to eq('Location "Somewhere"')
  end
end
