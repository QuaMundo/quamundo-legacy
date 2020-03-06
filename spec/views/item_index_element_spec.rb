RSpec.describe 'items/index', type: :view do
  include_context 'Session'
  let(:item)    { create(:item) }

  it 'shows an item index entry' do
    render partial: 'items/index_entry', locals: { index_entry: item }

    expect(rendered).to have_selector('li.index_entry')
    expect(rendered)
      .to have_selector('.index_entry_name', text: /#{item.name}/)
    expect(rendered)
      .to have_selector('.index_entry_description', text: /#{item.description}/)
    expect(rendered).to match /#{item.world.name}/
    expect(rendered).to match /#{item.facts.count}/
    expect(rendered).to match /#{item.relatives.count}/

    expect(rendered).to have_link(href: world_item_path(item.world, item))
    expect(rendered).to have_link(href: edit_world_item_path(item.world, item))
    expect(rendered).to have_link(href: world_item_path(item.world, item),
                                  id: /delete-.+/)
  end
end
