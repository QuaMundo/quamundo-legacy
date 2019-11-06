RSpec.shared_examples 'associated dossiers', type: :system do
  let(:path) { [subject.try(:world), subject] }

  before(:example) do
    subject.dossiers << Dossier.new(name: 'Test Dossier',
                                    content: 'Test',
                                    description: 'Desription of Test Dossier')
    visit(polymorphic_path(path))
    page.within('div#dossiers-header') do
      page.find('button').click
    end
  end

  it 'show up in details view' do
    expect(page)
      .to have_selector('[id^="index-entry-dossier-"]', count: subject.dossiers.count)
    # FIXME: Avoid each loops!
    subject.dossiers.each do |d|
      expect(page).to have_content(d.name)
      # FIXME: Description may be empty
      expect(page).to have_content(d.description)
      expect(page).to have_link(href: polymorphic_path(path))
    end
  end

  it 'can be created' do
    page.find('a#add-dossier').click
    expect(page).to have_current_path(new_polymorphic_path(path << Dossier))
    # further steps in `spec/system/dossiers/dossiers_spec.rb`
  end

  it 'can be edited' do
    edited_dossier = subject.dossiers.first
    page.find("a#edit-dossier-#{edited_dossier.id}").click
    expect(page).to have_current_path(edit_dossier_path(edited_dossier))
    expect(page)
      .to have_content("#{subject.model_name.human.capitalize} \"#{subject.try(:name) || subject.try(:name)}\"")
    # further steps in `spec/system/dossiers/dossiers_spec.rb`
  end

  it 'can be deleted', :js, :comprehensive do
    deleted_dossier = subject.dossiers.first
    page.accept_confirm() do
      page.find("a#delete-dossier-#{deleted_dossier.id}").click
    end
    expect(page).to have_current_path(polymorphic_path(path))
    expect(page).not_to have_selector("#dossier-#{deleted_dossier.id}")
    expect(Dossier.ids).not_to include(deleted_dossier.id)
  end
end
