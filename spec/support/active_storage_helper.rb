module ActiveStorageTestHelpers
  # Make `#fixture_file_upload` available
  # Prepare for ActiveStorage attachment testing, according to:
  # https://blog.eq8.eu/til/factory-bot-trait-for-active-storange-has_attached.html
  include ActionDispatch::TestProcess::FixtureFile

  def remove_uploads
    FileUtils::rm_rf(Rails.root.join('tmp/storage'))
  end

  def fixture_file_name(name)
    Rails.root.join('spec/fixtures/files/', name)
  end

  def open_fixture(file)
    File.open(fixture_file_name(file))
  end

  def attach_file(activestorageobj, filename)
    activestorageobj.attach(
      io: open_fixture(filename),
      filename: filename
    )
  end
end

