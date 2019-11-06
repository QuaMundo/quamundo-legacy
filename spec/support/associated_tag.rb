RSpec.shared_examples 'associated tags', type: :system do
  # FIXME: Maybe a helper `inventory_path` would be usefull
  let(:path) { [subject.try(:world), subject].compact }

  before(:example) do
    subject.save
  end

  context 'in show views' do
    before(:example) do
      visit(polymorphic_path(path))
    end

    it 'lists all tags' do
      subject.tag.tagset = [:a, :b, :c]
      subject.tag.save
      # FIXME: Thise repeats before action
      visit(polymorphic_path(path))
      expect(page).to have_selector('.tag', count: subject.tag.tagset.count)
      subject.tag.tagset
        .each { |t| expect(page).to have_selector('.tag', text: t) }
    end

    it 'provides link to edit' do
      page.find("a#edit-tag-#{subject.tag.id}").click
      expect(page).to have_current_path(edit_tag_path(subject.tag))
    end
  end

  context 'CRUD actions' do
    before(:example) do
      visit(edit_tag_path(subject.tag))
    end

    it 'can be edited' do
      expect(page)
        .to have_content("#{subject.model_name.human.capitalize} \"#{subject.try(:name) || subject.try(:title)}\"")
      expect(page).to have_selector(
        "#tag_tagset[@value=\"#{subject.tag.tagset.join(', ')}\"]")
      fill_in('tag_tagset', with: 'A neW tAg, another new tag')
      click_button('submit')
      expect(page).to have_current_path(polymorphic_path(path))
      subject.reload
      expect(subject.tag.tagset).to eq(['A neW tAg', 'another new tag'])
      expect(page).to have_selector('.tag', text: 'A neW tAg')
    end
  end
end
