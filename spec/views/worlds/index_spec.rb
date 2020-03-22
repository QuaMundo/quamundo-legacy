RSpec.describe 'worlds/index', type: :view do
  context 'unregistered user' do
    it 'does not show new world link' do
      render(partial: 'worlds/index_menu')
      expect(rendered).not_to have_link(href: new_world_path)
    end
  end

  context 'registered user' do
    include_context 'Session'

    it 'shows new world link' do
      render(partial: 'worlds/index_menu')
      expect(rendered).to have_link(href: new_world_path)
    end
  end
end
