# frozen_string_literal: true

RSpec.shared_examples 'associated tags', type: :system do
  let(:path) { [subject.try(:world), subject].compact }

  before(:example) do
    subject.save
  end

  context 'in show views' do
    it 'lists all tags' do
      subject.tag.tagset = %i[a b c]
      subject.tag.save
      visit(polymorphic_path(path))
      expect(page).to have_selector('.tag', count: subject.tag.tagset.count)
      subject.tag.tagset
             .each { |t| expect(page).to have_selector('.tag', text: t) }
    end
  end

  context 'CRUD actions' do
    it 'can be edited' do
      visit(edit_polymorphic_path(path))
      within('fieldset#tags-input') do
        selector = 'input[id$="_tag_attributes_tagset"]'
        expect(page).to have_selector(
          "#{selector}[value=\"#{subject.tag.tagset.join(', ')}\"]"
        )
        page
          .find(selector)
          .fill_in(with: 'A neW tAg, another new tag')
      end
      click_button('submit')
      expect(page).to have_current_path(polymorphic_path(path))
      subject.reload
      expect(subject.tag.tagset).to eq(['A neW tAg', 'another new tag'])
      expect(page).to have_selector('.tag', text: 'A neW tAg')
    end
  end
end
