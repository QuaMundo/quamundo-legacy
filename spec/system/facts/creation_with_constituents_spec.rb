RSpec.describe 'Creating a fact with constituents',
  type: :system, db_triggers: true, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)   { create(:world_with_inventories, user: user) }
  let(:item)    { world.items.first }
  let(:figure)  { world.figures.first }

  it 'can select and deselect constituents' do
    visit new_world_fact_path(world)
    # Fill in fact name
    fill_in('Name', with: 'Test-Fact')
    # Fill in new constituent
    fill_in('Roles', with: 'Role 1')
    page.find(
      'select[id^="fact_fact_constituents_attributes_"][id$="_constituable"]'
    ).select(item.name)
    # Add an constituent
    page.find('button#add-constituent').click
    expect(page).to have_selector("input[value=\"#{item.name} (Item)\"]")
    expect(page).to have_selector('input[value="Role 1"]')
    expect(page)
      .to have_selector("option[value=\"Item.#{item.id}\"][disabled]")
    # Fill in other constituent
    fill_in('Roles', with: 'Role 1, Role 2')
    page
      .find(
        'select[id^="fact_fact_constituents_attributes_"][id$="_constituable"]'
    ).select(figure.name)
    # Remove first constituent
    page.find('input[value="Role 1"]+div button').click
    expect(page).not_to have_selector('div div input[value="Role 1"]')
    expect(page)
      .not_to have_selector("option[value=\"Item.#{item.id}\"][disabled]")

    click_button('submit')
    expect(page).to have_content('Test-Fact')
    page.find('div#fact_constituents-header button').click
    expect(page).not_to have_content(item.name)
    expect(page).to have_content(figure.name)
  end
end
