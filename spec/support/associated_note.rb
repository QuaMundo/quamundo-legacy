RSpec.shared_examples 'associated note', type: :system do
  let(:path) { [subject.try(:world), subject] }

  before(:example) do
    visit(polymorphic_path(path))
    page.within('div#notes-header') do
      page.first('button').click
    end
  end

  it 'show up in details view' do
    expect(page).to have_selector('.note', count: subject.notes.count)
    subject.notes.each { |n| expect(page).to have_text(n.content) }
  end

  it 'can be created' do
    page.find('a#add-note').click
    expect(page).to have_current_path(new_polymorphic_path(path << Note))
    fill_in('note_content', with: 'This is my new note')
    click_button('submit')
    expect(page)
      .to have_current_path(polymorphic_path([subject.try(:world), subject]))
    expect(page).to have_content('This is my new note')
  end

  it 'can be edited' do
    edited_note = subject.notes.first
    page.find("a#edit-note-#{edited_note.id}").click
    expect(page).to have_current_path(edit_note_path(edited_note))
    expect(page)
      .to have_content("#{subject.model_name.human.capitalize} \"#{subject.try(:name) || subject.try(:title)}\"")
    fill_in('note_content', with: 'Updated note')
    click_button('submit')
    expect(page).to have_current_path(polymorphic_path(path))
    expect(page).to have_content('Updated note')
  end

  it 'can be deleted', :js, :comprehensive do
    deleted_note = subject.notes.first
    res = page.accept_confirm() do
      page.find("a#delete-note-#{deleted_note.id}").click
    end
    expect(res).not_to match(/translation missing/i)
    expect(page).to have_current_path(polymorphic_path(path))
    expect(page).not_to have_selector("#note-#{deleted_note.id}")
    expect(Note.ids).not_to include(deleted_note.id)
  end
end
