class CheckPermissionUserNotOwner < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # Add constraint trigger to forbid adding permission to world owner
        execute <<~SQL
          -- create function
          CREATE FUNCTION permission_user_may_not_be_owner()
          RETURNS TRIGGER AS $$
            BEGIN
              IF ((SELECT count(*) FROM worlds w
                      WHERE w.id = NEW.world_id AND
                      w.user_id = NEW.user_id) > 0)
              THEN
                RAISE EXCEPTION 'Permissions: user may not be owner of world';
              ELSE
                RETURN NEW;
              END IF;
            END;
          $$ LANGUAGE plpgsql;

          -- create trigger
          CREATE TRIGGER user_may_not_be_owner_of_permission
            AFTER INSERT
              ON permissions
                FOR EACH ROW EXECUTE PROCEDURE permission_user_may_not_be_owner();
        SQL
      end

      dir.down do
        # Drop contraint trigger
        execute <<~SQL
          -- drop trigger
          DROP TRIGGER user_may_not_be_owner_of_permission
            ON permissions;

          -- drop function
          DROP FUNCTION permission_user_may_not_be_owner();
        SQL
      end
    end
  end
end
