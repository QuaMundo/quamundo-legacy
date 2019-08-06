class AddConstraintEndAfterStartDateToFacts < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<~EOSQL
          ALTER TABLE facts
            ADD CONSTRAINT start_before_end_date
              CHECK ((start_date IS NULL) OR
                     (end_date IS NULL) OR
                     (start_date < end_date))
        EOSQL
      end

      dir.down do
        execute <<~EOSQL
          ALTER TABLE facts
            DROP CONSTRAINT start_before_end_date
        EOSQL
      end
    end
  end
end
