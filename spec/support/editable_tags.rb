# frozen_string_literal: true

RSpec.shared_examples 'editable tags', type: :system do
  # Expect `path` to be present
  before(:example) do
    visit path
    fill_in('Name', with: 'test')
  end

  it 'lets enter tags' do
    page.find('input[id$="_tag_attributes_tagset"]')
        .fill_in(with: 'tag 1, tag 2, tag 3')
    click_button('submit')
    page.within('.tagset') do
      ['tag 1', 'tag 2', 'tag 3'].each do |tag|
        expect(page).to have_selector('.tag', text: tag)
      end
    end
  end
end
