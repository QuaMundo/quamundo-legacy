RSpec.describe 'dashboard/index', type: :view do
  include_context 'Session'

  before(:example) do
    user.worlds << build(:world,
                         title: 'My World',
                         description: 'A tiny sample world, lovely and nice.',
                         user: user)
    allow(view).to receive(:current_user).and_return(user)
  end

  it 'shows a world card' do
    render
    expect(rendered).to match /My World/
    expect(rendered).to match /A tiny sample/
    expect(rendered).to match /#{user.nick}/
  end
end
