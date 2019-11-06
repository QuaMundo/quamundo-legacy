RSpec.describe 'Updating a fact with constituents',
  type: :system, db_triggers: true, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)   { build(:world_with_inventories, user: user) }
  let(:fact)    { build(:fact, world: world) }

  let(:item)      { world.items.first }
  let(:figure)    { world.figures.first }
  let(:location)  { world.locations.first }

  let!(:const_1) { create(:fact_constituent, fact: fact, constituable: item) }
  let!(:const_2) { create(:fact_constituent, fact: fact, constituable: figure) }

  it 'can add an constituent' do
    visit edit_world_fact_path(world, fact)

    expect(page).not_to have_selector(
      "option[value=\"#{item.name}.#{item.id.to_s}\"]")
    expect(page).not_to have_selector(
      "option[value=\"#{figure.name}.#{figure.id.to_s}\"]")
    expect(page).to have_selector("input[value=\"#{figure.name} (Figure)\"]")
    expect(page).to have_selector("input[value=\"#{item.name} (Item)\"]")

    # Add a new constituent
    fill_in('Roles', with: 'Role 1')
    page.find(
      'select[id^="fact_fact_constituents_attributes_"][id$="_constituable"]'
    ).select(location.name)
    page.find('button#add-constituent').click
    expect(page)
      .to have_selector("input[value=\"#{location.name} (Location)\"]")

    # Remove existing constituent
    i = page.find("input[value=\"#{item.name} (Item)\"]").find(:xpath, '../..')
    i.find('button').click
    expect(i).to have_selector(
      'input[type="hidden"][id$="_destroy"][value="1"]', visible: false
    )

    click_button('submit')
    page.find('div#fact_constituents-header button').click
    expect(page).to have_content(location.name)
    expect(page).to have_content(figure.name)
    expect(page).not_to have_content(item.name)
  end
end
