RSpec.describe 'CRUD actions on dossiers', type: :system do
  # FIXME: Refactor `Session`
  include_context 'Session'

  context 'create a dossier' do
    let(:world) { create(:world, user: user) }

    before(:example) { visit(new_polymorphic_path([world, Dossier])) }

    it 'succeeds with proper filled form' do
      dossiers_count = world.dossiers.count
      fill_in('Title', with: 'New Dossier')
      fill_in('Content', with: 'Some content')
      files = %w(earth.jpg file.pdf).map { |f| fixture_file_name(f) }
      page.attach_file('dossier_files', files)
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_content('New Dossier')
      expect(page).to have_content('Some content')
      expect(world.dossiers.count).to be > dossiers_count
      expect(page).to have_link('earth.jpg')
      expect(page).to have_link('file.pdf')
      expect(page).to have_selector('.alert.alert-info', text: /^Dossier/)
      # expect(page).to have_current_path(%r(dossiers/#{Dossier.last.id}))
    end

    it 'renders form again if required fields are missing' do
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_selector('.alert.alert-danger')
    end

    it_behaves_like 'valid_view' do
      let(:path) { new_polymorphic_path([world, Dossier]) }
    end
  end

  context 'edit a dossier' do
    let(:dossier) { create(:world_with_dossiers).dossiers.first }

    before(:example) { visit(edit_dossier_path(dossier)) }

    it 'refuses to save dossier w/o title' do
      fill_in('Title', with: nil)
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_selector('.alert.alert-danger')
    end

    it 'refuses to save dossier w/o content' do
      fill_in('Content', with: nil)
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_selector('.alert.alert-danger')
    end

    it 'saves with completed form' do
      fill_in('Title', with: 'New Dossier')
      fill_in('Description', with: 'Description of new dossier')
      fill_in('Content', with: 'Content of new dossier')
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(page).to have_content('New Dossier')
      expect(page).to have_content('Description of new dossier')
      # FIXME: Test this for html rendered markdown
      expect(page).to have_content('Content of new dossier')
      expect(page).to have_link(href: polymorphic_path(dossier.dossierable))
      # expect(page).to have_current_path(%r(dossiers/#{dossier.id}))
    end

    it_behaves_like 'valid_view' do
      let(:path) { edit_dossier_path(dossier) }
    end
  end

  context 'showing a dossier' do
    let(:dossier) do
      content = <<~EOT
        # Heading 1

        ## Heading 2

        This is just a paragraph.

        * List Item 1
        * List Item 2
      EOT

      create(:dossier, content: content, dossierable: build(:world))
    end

    it 'renders markdown content as html' do
      visit(dossier_path(dossier))
      page.within('#content') do
        expect(page).to have_selector('h1', text: 'Heading 1')
        expect(page).to have_selector('h2', text: 'Heading 2')
        expect(page).to have_selector('p', text: /^This is just/)
        expect(page).to have_selector('li', text: 'List Item 1')
        expect(page).to have_selector('li', text: 'List Item 2')
      end
    end

    it_behaves_like 'valid_view' do
      let(:path) { edit_dossier_path(dossier) }
    end
  end

  context 'handling attachments' do
    let(:dossier) { create(:dossier, dossierable: build(:world)) }

    it 'adds an attachment' do
      no_attachments = dossier.files.count
      visit(edit_dossier_path(dossier))
      page.attach_file('dossier_files', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(page).to be_i18n_ready
      #dossier.reload
      expect(dossier.files.count).to be > no_attachments
      expect(page).to have_link('file.pdf')
    end

    it 'removes attachments marked for removal' do
      files = %w(earth.jpg file.pdf item.jpg).map do |file|
        f = fixture_file_name(file)
        dossier.files.attach(fixture_file_upload(f))
      end
      file_ids = [dossier.files.ids.first, dossier.files.ids.last]
      visit(edit_dossier_path(dossier))
      check(element_id(dossier.files.find(file_ids).first, 'remove'))
      check(element_id(dossier.files.find(file_ids).last, 'remove'))
      click_button('submit')
      expect(page).to be_i18n_ready
      expect(dossier.files.ids).not_to include(*file_ids)
    end

    it 'deletes all attachments when dossier is deleted', :comprehensive do
      files = %w(earth.jpg file.pdf).map do |file|
        f = fixture_file_name(file)
        dossier.files.attach(fixture_file_upload(f))
      end
      file_ids = dossier.files.ids
      dossier.destroy
      # FIXME: Try to avoid sleeping - purging files seems to need some time
      sleep 0.2
      expect(ActiveStorage::Blob.ids).not_to include(*file_ids)
    end
  end
end
