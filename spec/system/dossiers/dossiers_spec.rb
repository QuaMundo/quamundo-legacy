# frozen_string_literal: true

RSpec.describe 'CRUD actions on dossiers', type: :system do
  include_context 'Session'

  context 'create a dossier' do
    let(:world) { create(:world, user: user) }

    before(:example) do
      visit(new_polymorphic_path(
              [world, Dossier],
              dossier: {
                dossierable_type: 'World',
                dossierable_id: world.id
              }
            ))
    end

    it 'succeeds with proper filled form' do
      dossiers_count = world.dossiers.count
      fill_in('Name', with: 'New Dossier')
      fill_in('Content', with: 'Some content')
      files = %w[earth.jpg file.pdf].map { |f| fixture_file_name(f) }
      page.attach_file('dossier_files', files)
      click_button('submit')
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
      expect(page).to have_selector('.alert.alert-danger')
    end

    it_behaves_like 'valid_view' do
      let(:path) do
        new_polymorphic_path(
          [world, Dossier],
          dossier: {
            dossierable_type: 'World',
            dossierable_id: world.id
          }
        )
      end
    end
  end

  context 'edit a dossier' do
    let(:dossier) { create(:world_with_dossiers, user: user).dossiers.first }

    before(:example) { visit(edit_dossier_path(dossier)) }

    it 'refuses to save dossier w/o name' do
      fill_in('Name', with: nil)
      click_button('submit')
      expect(page).to have_selector('.alert.alert-danger')
    end

    it 'saves with completed form' do
      fill_in('Name', with: 'New Dossier')
      fill_in('Description', with: 'Description of new dossier')
      fill_in('Content', with: 'Content of new dossier')
      click_button('submit')
      expect(page).to have_content('New Dossier')
      expect(page).to have_content('Description of new dossier')
      expect(page).to have_content('Content of new dossier')
      expect(page).to have_link(href: polymorphic_path(dossier.dossierable))
    end

    it_behaves_like 'valid_view' do
      let(:path) { edit_dossier_path(dossier) }
    end
  end

  context 'showing a dossier' do
    let(:dossier) do
      content = <<~ENDOFTEXT
        # Heading 1

        ## Heading 2

        This is just a paragraph.

        * List Item 1
        * List Item 2
      ENDOFTEXT

      create(:dossier, content: content, dossierable: build(:world, user: user))
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
    let(:dossier) { create(:dossier, dossierable: build(:world, user: user)) }

    it 'adds an attachment' do
      dossier.files.attach(fixture_file_upload(fixture_file_name('earth.jpg')))
      dossier.files.attach(fixture_file_upload(fixture_file_name('htrae.jpg')))
      no_attachments = dossier.files.count
      visit(edit_dossier_path(dossier))
      expect(page).to have_selector('label', text: 'Earth.jpg')
      page.attach_file('dossier_files', fixture_file_name('file.pdf'))
      click_button('submit')
      expect(dossier.files.count).to be > no_attachments
      expect(page).to have_link('file.pdf')
      expect(page).to have_link('earth.jpg')
      expect(page).to have_link('htrae.jpg')
    end

    it 'removes attachments marked for removal' do
      %w[earth.jpg file.pdf item.jpg].map do |file|
        f = fixture_file_name(file)
        dossier.files.attach(fixture_file_upload(f))
      end
      file_ids = [dossier.files.ids.first, dossier.files.ids.last]
      visit(edit_dossier_path(dossier))
      check(element_id(dossier.files.find(file_ids).first, 'remove'))
      check(element_id(dossier.files.find(file_ids).last, 'remove'))
      click_button('submit')
      dossier.reload
      expect(dossier.files.ids).not_to include(*file_ids)
    end

    it 'deletes all attachments when dossier is deleted', :comprehensive do
      %w[earth.jpg file.pdf].map do |file|
        f = fixture_file_name(file)
        dossier.files.attach(fixture_file_upload(f))
      end
      file_ids = dossier.files.ids
      dossier.destroy
      expect(ActiveStorage::Blob.ids).not_to include(*file_ids)
    end

    it 'renders image sliders' do
      %w[earth.jpg htrae.jpg video.m4v audio.mp3].map do |file|
        f = fixture_file_name(file)
        dossier.files.attach(fixture_file_upload(f))
      end
      visit dossier_path(dossier)
      expect(page).to have_selector('img.q-slide', count: 2)
      expect(page).to have_selector('audio', count: 1)
      expect(page).to have_selector('video', count: 1)
    end
  end
end
