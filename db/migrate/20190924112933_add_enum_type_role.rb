class AddEnumTypeRole < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # create enum type for roles
        execute <<~SQL
          CREATE TYPE relation_role AS ENUM ('subject', 'relative');
        SQL
      end

      dir.down do
        # drop 
        execute <<~SQL
          DROP TYPE relation_role;
        SQL
      end
    end
  end
end
