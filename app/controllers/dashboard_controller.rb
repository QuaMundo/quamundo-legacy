# FIXME: This has to be changed when permissions are added
# i.e. Do not only list owned objects, list accessible objs, too
class DashboardController < ApplicationController
  before_action :set_worlds, :set_inventories

  def index
    authorize! @worlds, with: WorldPolicy
    # FIXME: @inventories is not authorized?
    # authorize! @inventories
  end

  private
  INVENTORY_SQL = <<~SQL
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
    WHERE u.id = :user_id
    ORDER BY updated_at DESC
    LIMIT :limit;
  SQL

  # FIXME: Hard coded limit!
  WORLD_SQL = <<~SQL
    SELECT DISTINCT w.*
    FROM worlds w
    LEFT OUTER JOIN permissions p
    ON w.id = p.world_id
    WHERE (
      (p.permissions = 'public') OR
      ((p.user_id = :user_id) AND (p.permissions IN ('r', 'rw'))) OR
      (w.user_id = :user_id)
    )
    ORDER BY w.updated_at DESC
    LIMIT 4;
  SQL

  def set_worlds
    @worlds = World
      .find_by_sql([WORLD_SQL, { user_id: current_user.try(:id) }])
  end

  def set_inventories
    @inventories = Inventory
      .find_by_sql([INVENTORY_SQL,
                    { user_id: current_user.try(:id),
                      limit: limit ||= 15 }])
  end
end
