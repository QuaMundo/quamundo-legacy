RSpec.shared_examples 'associated tags', type: :system do
  let(:path) { [subject.try(:world), subject].reject(&:nil?) }

  before(:example) do
    visit(polymorphic_path(path))
  end

  it 'has a tagset' do
    expect(subject).to respond_to(:tag)
    expect(subject.tag).not_to be_nil
    expect(subject.tag.tagset).to be_an Array
  end

  it 'show up in details view' do
    expect(page).to have_selector('.tag', count: subject.tag.tagset.count)
    subject.tag.tagset
      .each { |t| expect(page).to have_selector('.tag', text: t) }
  end

  it 'can be edited' do
    edited_tag = subject.tag
    page.find('#tags-header button').click
    page.find("a#edit-tag-#{edited_tag.id}").click
    expect(page).to have_current_path(edit_tag_path(edited_tag))
    expect(page).to have_selector(
      "#tag_tagset[@value=\"#{edited_tag.tagset.join(', ')}\"]")
    fill_in('tag_tagset', with: 'A neW tAg, another new tag')
    click_button('submit')
    expect(page).to have_current_path(polymorphic_path(path))
    subject.reload
    expect(subject.tag.tagset).to eq(['a_new_tag', 'another_new_tag'])
    expect(page).to have_selector('.tag', text: 'a_new_tag')
  end

  it 'can be deleted', :js do
    page.find('#tags-header button').click
    deleted_tag = subject.tag
    page.accept_confirm() do
      page.find("a#delete-tag-#{deleted_tag.id}").click
    end
    expect(page).to have_current_path(polymorphic_path(path))
    page.within('#tags') do
      deleted_tag.tagset.each do |t|
        expect(page).not_to have_selector('.tag', text: t)
      end
    end
    subject.reload
    expect(subject.tag.tagset).to be_empty
  end
end
