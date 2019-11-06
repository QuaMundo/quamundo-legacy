class DashboardController < ApplicationController
  before_action :set_objects

  def index
  end

  private
  SQL = <<~SQL
    SELECT i.* FROM
    worlds w
    INNER JOIN (
      SELECT * FROM inventories i
      UNION SELECT
        f.id          AS inventory_id,
        'Fact'        AS inventory_type,
        f.name        AS name,
        f.description AS description,
        f.updated_at  AS updated_at,
        w.id          AS world_id
      FROM facts f
      INNER JOIN worlds w ON f.world_id = w.id ) i
    ON w.id = i.world_id
    INNER JOIN users u ON w.user_id = u.id
    WHERE u.id = ?
    ORDER BY updated_at DESC
    LIMIT ?;
  SQL

  def set_objects
    @worlds = current_user.worlds.last_updated
    @inventories = Inventory
      .find_by_sql([SQL, current_user.id, limit ||= 15])
  end
end
