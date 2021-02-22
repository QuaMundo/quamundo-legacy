namespace :db do
  def refresh_materialized_views
    # Add models which use materialized views here
    Inventory.refresh
    SubjectRelativeRelation.refresh
  end

  desc "Refresh materialized views"
  task refresh: :environment do
    refresh_materialized_views
  end

  task setup: :environment do
    refresh_materialized_views
  end
end
