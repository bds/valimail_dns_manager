class CreateZone < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TABLE zones(
             id             INTEGER PRIMARY KEY,
             name           TEXT    NOT NULL,
             updated_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
             UNIQUE (name)
          );
        SQL
      end
      dir.down do
        execute <<~SQL
          DROP TABLE zones
        SQL
      end
    end
  end
end
