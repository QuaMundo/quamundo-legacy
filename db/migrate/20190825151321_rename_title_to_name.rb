class RenameTitleToName < ActiveRecord::Migration[5.2]
  def change
    # change field name `title` to `name` for
    # `dossiers` and `worlds`
    reversible do |dir|
      dir.up do
        # remove indexes
        remove_index :worlds, :title

        # change names
        rename_column :worlds, :title, :name
        rename_column :dossiers, :title, :name

        # add indexes
        add_index :worlds, :name
      end

      dir.down do
        # remove indexes
        remove_index :worlds, :name

        # change names
        rename_column :worlds, :name, :title
        rename_column :dossiers, :name, :title

        # add indexes
        add_index :worlds, :title
      end
    end
  end
end
