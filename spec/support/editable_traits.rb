RSpec.shared_examples 'editable traits', type: :system do
  # Expect `path` to be present
  before(:example) do
    visit path
    begin
      # A world has an immutable name - so, name is not the thing we want
      # to test, errors should be ignored
      fill_in('Name', with: 'Test-Name')
    rescue
    end
  end

  it 'lets enter and remove multiple attributes', :js do
    page.find('[data-id="trait_new_key"]')
      .fill_in(with: 'new_key_1')
    page.find('[data-id="trait_new_value"]')
      .fill_in(with: 'new_value_1')
    click_button('add-trait')
    expect(page).to have_selector('label', text: 'new_key_1')
    expect(page)
      .to have_selector('input[id$="_attributeset_new_key_1')
    page.find('[data-id="trait_new_key"]')
      .fill_in(with: 'new_key_2')
    page.find('[data-id="trait_new_value"]')
      .fill_in(with: 'new_value_2')
    click_button('add-trait')
    page.find('[data-id="trait_new_key"]')
      .fill_in(with: 'new_key_3')
    page.find('[data-id="trait_new_value"]')
      .fill_in(with: 'new_value_3')
    page.find('input[id$="_attributeset_new_key_2"] + div button').click
    expect(page).not_to have_selector('label', text: 'new_key_2')
    expect(page)
      .not_to have_selector('input[id$="_attributeset_new_key_2"]')
    click_button('submit')
    page.find('div#traits-header button').click
    expect(page).to have_content('new_value_1')
    expect(page).to have_content('new_value_3')
    expect(page).to have_content('new_key_1')
    expect(page).to have_content('new_key_3')
    expect(page).not_to have_content('new_key_2')
    expect(page).not_to have_content('new_value_2')
  end
end
