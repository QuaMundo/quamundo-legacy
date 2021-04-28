# frozen_string_literal: true

RSpec.shared_examples 'editable traits', type: :system do
  # expect subject to be present
  it 'lets enter and remove multiple attributes', :js do
    visit edit_polymorphic_path([subject.try(:world), subject])
    # Check for existing attributes
    expect(page)
      .to have_selector('input[value="key 1"][readonly]')
    expect(page)
      .to have_selector('input[value="key 2"][readonly]')
    expect(page)
      .to have_selector('input[value="value 1"]')
    expect(page)
      .to have_selector('input[value="value 2"]')
    # Remove attr 'key 1'
    page.find('input[value="value 1"]+div button').click
    expect(page)
      .not_to have_selector('input[value="key 1"][readonly]')
    expect(page)
      .not_to have_selector('input[value="value 1"]')
    # Add a new attribute
    page
      .find('input[id$="_trait_attributes_attributeset_key_new_key"]')
      .fill_in(with: 'super new key')
    page
      .find('input[id$="_trait_attributes_attributeset_value_new_value"]')
      .fill_in(with: 'super new value')
    page.find('button[id="add-trait"]').click
    expect(page)
      .to have_selector('input[value="super new value"]')
    expect(page)
      .to have_selector('input[value="super new key"]')
    # Add another attribute
    page
      .find('input[id$="_trait_attributes_attributeset_key_new_key"]')
      .fill_in(with: 'another new key')
    page
      .find('input[id$="_trait_attributes_attributeset_value_new_value"]')
      .fill_in(with: 'another new value')
    # Remove first added attribute
    page.find('input[value="super new value"]+div button').click
    expect(page)
      .not_to have_selector('input[value="super new value"]')
    expect(page)
      .not_to have_selector('input[value="super new key"]')
    click_button('submit')
    expect(page)
      .to have_selector('th', text: 'key 2', visible: false)
    expect(page)
      .not_to have_selector('th', text: 'key 1', visible: false)
    expect(page)
      .to have_selector('td', text: 'value 2', visible: false)
    expect(page)
      .not_to have_selector('td', text: 'value 1', visible: false)
    expect(page)
      .to have_selector('th', text: 'another new key', visible: false)
    expect(page)
      .to have_selector('td', text: 'another new value', visible: false)
    expect(page)
      .not_to have_selector('th', text: 'super new key', visible: false)
    expect(page)
      .not_to have_selector('td', text: 'super new value', visible: false)
  end

  it 'does not treat empty attributes' do
    attributes_count = subject.trait.attributeset.count
    visit edit_polymorphic_path([subject.try(:world), subject])
    click_button('submit')
    subject.reload
    expect(subject.trait.attributeset.count).to eq(attributes_count)
  end
end
