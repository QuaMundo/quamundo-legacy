class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # Create enum type `permissions`:
        # * public    - public readable
        # * r         - read
        # * rw        - read and write
        execute <<~SQL
          CREATE TYPE permission_type AS ENUM ('public', 'r', 'rw');
        SQL
      end

      dir.down do
        # Drop enum type `permissions`
        execute <<~SQL
          DROP TYPE permission_type;
        SQL
      end
    end

    create_table :permissions do |t|
      t.references :world, foreign_key: true, index: true, null: false
      t.references :user, foreign_key: true, index: true
      t.column :permissions, :permission_type, null: false
    end

    add_index :permissions, [:world_id, :user_id], unique: true
  end
end
