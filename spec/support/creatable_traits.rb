RSpec.shared_examples 'creatable traits', type: :system do
  # Expect `path` to be present
  before(:example) do
    visit path
    begin
      # A world has an immutable name - so, name is not the thing we want
      # to test, errors should be ignored
      # FIXME: Is there a way to solve above issue?
      fill_in('Name', with: 'Test-Name')
    rescue
    end
  end

  it 'lets enter and remove multiple attributes', :js do
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
      .to have_selector('th', text: 'another new key', visible: false)
    expect(page)
      .to have_selector('td', text: 'another new value', visible: false)
    expect(page)
      .not_to have_selector('th', text: 'super new key', visible: false)
    expect(page)
      .not_to have_selector('td', text: 'super new value', visible: false)
  end
end
