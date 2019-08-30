class ChangeConstituentsOnSubjectRelativeRelations < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # drop triggers
        execute <<~SQL
          DROP TRIGGER refresh_constituent_on_subject_relative_relations
          ON relation_constituents;
        SQL

        execute <<~SQL
          DROP TRIGGER refresh_relation_on_subject_relative_relations
          ON relations;
        SQL

        # drop trigger function
        execute <<~SQL
          DROP FUNCTION refresh_subject_relative_relations();
        SQL

        # drop materialzed view
        execute <<~SQL
          DROP MATERIALIZED VIEW subject_relative_relations;
        SQL

        # create materialized view
        execute <<~SQL
          CREATE MATERIALIZED VIEW subject_relative_relations AS
            SELECT 
              sc.relation_id AS relation_id,
              sc.id AS subject_id,
              r.name AS name,
              rc.id AS relative_id
            FROM relation_constituents sc
            JOIN relation_constituents rc
            ON sc.relation_id = rc.relation_id AND sc.role != rc.role
            JOIN relations r ON r.id = sc.relation_id
            WHERE sc.role = 'subject'
            UNION
            SELECT
              sc.relation_id AS relation_id,
              sc.id AS subject_id,
              r.reverse_name AS name,
              rc.id AS relative_id
            FROM relation_constituents sc
            JOIN relation_constituents rc
            ON sc.relation_id = rc.relation_id AND sc.role != rc.role
            JOIN relations r ON r.id = sc.relation_id
            WHERE sc.role = 'relative' AND r.reverse_name IS NOT NULL
          WITH DATA;
        SQL

        # create trigger function
        execute <<~SQL
          CREATE FUNCTION refresh_subject_relative_relations()
          RETURNS trigger AS $$
            BEGIN
              REFRESH MATERIALIZED VIEW subject_relative_relations;
              RETURN NULL;
            END;
          $$ LANGUAGE plpgsql;
        SQL

        # create triggers
        # relation
        execute <<~SQL
          CREATE TRIGGER refresh_relation_on_subject_relative_relations
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON relations FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_subject_relative_relations();
        SQL

        # relation_constituent
        execute <<~SQL
          CREATE TRIGGER refresh_constituent_on_subject_relative_relations
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON relation_constituents FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_subject_relative_relations();
        SQL
      end

      dir.down do
        # drop triggers
        execute <<~SQL
          DROP TRIGGER refresh_constituent_on_subject_relative_relations
          ON relation_constituents;
        SQL

        execute <<~SQL
          DROP TRIGGER refresh_relation_on_subject_relative_relations
          ON relations;
        SQL

        # drop trigger function
        execute <<~SQL
          DROP FUNCTION refresh_subject_relative_relations();
        SQL

        # drop materialzed view
        execute <<~SQL
          DROP MATERIALIZED VIEW subject_relative_relations;
        SQL

        # create materialized view
        execute <<~SQL
          CREATE MATERIALIZED VIEW subject_relative_relations AS
            SELECT 
              sc.relation_id AS relation_id,
              sc.fact_constituent_id AS subject_id,
              r.name AS name,
              rc.fact_constituent_id AS relative_id
            FROM relation_constituents sc
            JOIN relation_constituents rc
            ON sc.relation_id = rc.relation_id AND sc.role != rc.role
            JOIN relations r ON r.id = sc.relation_id
            WHERE sc.role = 'subject'
            UNION
            SELECT
              sc.relation_id AS relation_id,
              sc.fact_constituent_id AS subject_id,
              r.reverse_name AS name,
              rc.fact_constituent_id AS relative_id
            FROM relation_constituents sc
            JOIN relation_constituents rc
            ON sc.relation_id = rc.relation_id AND sc.role != rc.role
            JOIN relations r ON r.id = sc.relation_id
            WHERE sc.role = 'relative' AND r.reverse_name IS NOT NULL
          WITH DATA;
        SQL

        # create trigger function
        execute <<~SQL
          CREATE FUNCTION refresh_subject_relative_relations()
          RETURNS trigger AS $$
            BEGIN
              REFRESH MATERIALIZED VIEW subject_relative_relations;
              RETURN NULL;
            END;
          $$ LANGUAGE plpgsql;
        SQL

        # create triggers
        # relation
        execute <<~SQL
          CREATE TRIGGER refresh_relation_on_subject_relative_relations
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON relations FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_subject_relative_relations();
        SQL

        # relation_constituent
        execute <<~SQL
          CREATE TRIGGER refresh_constituent_on_subject_relative_relations
            AFTER UPDATE OR DELETE OR INSERT OR TRUNCATE
            ON relation_constituents FOR EACH STATEMENT
            EXECUTE PROCEDURE refresh_subject_relative_relations();
        SQL
      end
    end

    # Indices for subject_relative_relations
    add_index :subject_relative_relations,
      [:relation_id, :subject_id],
      name: 'index_relation_subject_on_sub_rel_relations'
    add_index :subject_relative_relations,
      [:relation_id, :relative_id],
      name: 'index_relation_relative_on_sub_rel_relations'
  end
end
