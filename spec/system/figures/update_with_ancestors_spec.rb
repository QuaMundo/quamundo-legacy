RSpec.describe 'Updating a figure with ancestors',
  type: :system, db_triggers: true, js: true, comprehensive: true do
  include_context 'Session'

  let(:world)     { create(:world, user: user) }
  let!(:figure)   { create(:figure, world: world) }
  let!(:father)   { create(:figure, world: world) }
  let!(:mother)   { create(:figure, world: world) }
  let!(:other)    { create(:figure, world: world) }
  let!(:stranger) { create(:figure) }

  it 'can select and deselect ancestors' do
    #figure.ancestors << other
    figure.figure_ancestors.create(ancestor: other, name: 'other ancestor')
    visit(edit_world_figure_path(world, figure))
    # Check all and only possible ancestors are listed
    page.within('fieldset#figure_ancestors-input') do
      [mother, father].each do |fig|
        expect(page).to have_selector('option', text: fig.name)
      end
      [figure, stranger, other].each do |fig|
        expect(page).not_to have_selector('option', text: fig.name)
      end
      expect(page).
        to have_selector("input[value=\"#{other.id}\"]", visible: false)
      expect(page).to have_selector("input[value=\"#{other.name}\"]")
      # Remove `other`
      page.find('input[value="other ancestor"]+div button').click
      expect(page)
        .to have_selector(
          "input[value=\"#{other.id}\"]+input[type=\"hidden\"][value=\"1\"]",
          visible: false
      )
      # add mother
      asel = 'select[id^="figure_figure_ancestors_attributes"][id$="ancestor_id"]'
      nsel = 'input[id^="figure_figure_ancestors_attributes"][id$="-1_name"]'
      page.find(asel).select(mother.name)
      page.find(nsel).fill_in(with: 'Mother')
      page.find('button#add-ancestor').click
      expect(page)
        .to have_selector("input[value=\"#{mother.id}\"]", visible: false)
      expect(page).to have_selector('input[value="Mother"]')
      # add father
      page.find(asel).select(father.name)
      page.find(nsel).fill_in(with: 'Father')
      page.find('button#add-ancestor').click
      expect(page)
        .to have_selector("input[value=\"#{father.id}\"]", visible: false)
      expect(page).to have_selector('input[value="Father"]')
    end
    # submit
    click_button('submit')
    figure.reload
    expect(figure.ancestors).to contain_exactly(mother, father)
    expect(mother.descendants).to contain_exactly(figure)
    expect(father.descendants).to contain_exactly(figure)
    %w(Mother Father).each do |fig|
      expect(figure.figure_ancestors.find_by(name: fig)).to be
    end
    expect(page).to have_current_path(world_figure_path(world, figure))
  end
end
