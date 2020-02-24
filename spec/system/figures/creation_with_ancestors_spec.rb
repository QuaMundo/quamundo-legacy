RSpec.describe 'Creating a figure with ancestors',
  type: :system, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)     { create(:world, user: user) }
  let!(:father)   { create(:figure, world: world) }
  let!(:mother)   { create(:figure, world: world) }
  let!(:other)    { create(:figure, world: world) }

  it 'can select and deselect ancestors' do
    visit new_world_figure_path(world)
    fill_in('Name', with: 'New Figure')
    asel = 'select[id^="figure_figure_ancestors_attributes"][id$="ancestor_id"]'
    nsel = 'input[id^="figure_figure_ancestors_attributes"][id$="-1_name"]'
    [mother, father, other].map(&:id).each do |fig|
      expect(page).to have_selector("option[value=\"#{fig}\"]")
    end
    # add an ancestor (father)
    page.find(asel).select(father.name)
    page.find(nsel).fill_in(with: 'Father')
    page.find('button#add-ancestor').click
    expect(page).to have_selector("input[value=\"#{father.name}\"]")
    expect(page).to have_selector('input[value="Father"]')
    # FIXME: Check options
    # add an ancestor (other)
    page.find(asel).select(other.name)
    page.find(nsel).fill_in(with: 'Other')
    page.find('button#add-ancestor').click
    expect(page).to have_selector("input[value=\"#{other.name}\"]")
    expect(page).to have_selector('input[value="Other"]')
    # add an ancestor (mother)
    page.find(asel).select(mother.name)
    page.find(nsel).fill_in(with: 'Mother')
    # remove ancestor (other)
    page.find('input[value="Other"]+div button').click
    expect(page).not_to have_selector("input[value=\"#{other.name}\"]")
    expect(page).not_to have_selector('input[value="Other"]')
    # submit
    click_button('submit')
    mother.reload
    father.reload
    figure = mother.descendants.first
    expect(mother.descendants.first).to eq(figure)
    expect(father.descendants.first).to eq(figure)
    expect(other.descendants).to be_empty
    expect(page).to have_current_path(
      world_figure_path(world, mother.descendants.first)
    )
  end
end
