module QuamundoTestHelpers
  # Make `#fixture_file_upload` available
  # Prepare for ActiveStorage attachment testing, according to:
  # https://blog.eq8.eu/til/factory-bot-trait-for-active-storange-has_attached.html
  include ActionDispatch::TestProcess::FixtureFile
  include ActiveSupport::Testing::TimeHelpers
  include ApplicationHelper

  def cleanup_test_environment
    remove_uploads
    reset_db_sequences
    refresh_materialized_views
  end

  def remove_uploads
    FileUtils::rm_rf(Rails.root.join('tmp/storage'))
  end

  def reset_db_sequences
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
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

  def refresh_materialized_views(model = nil)
    if model.nil?
      Inventory.refresh
      SubjectRelativeRelation.refresh
    else
      model.refresh
    end
  end

  # get random inventory type
  def random_inventory_type
    [:concept, :figure, :item, :location][rand(4)]
  end

  # create some inventory to fill up worlds
  def create_some_inventory(user)
    user.worlds.each do |world|
      travel(rand 5.days) { world.items << build(:item) }
      travel(rand 5.days) { world.figures << build(:figure) }
      travel(rand 5.days) { world.locations << build(:location) }
      travel(rand 5.days) { world.facts << build(:fact) }
      travel(rand 5.days) { world.concepts << build(:concept) }
    end
  end
end

