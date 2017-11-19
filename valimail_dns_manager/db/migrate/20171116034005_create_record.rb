class CreateRecord < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TABLE records(
             id             INTEGER PRIMARY KEY,
             name           TEXT    NOT NULL,
             ttl            INT     NOT NULL,
             record_type    TEXT    CHECK (record_type IN ('A', 'CNAME')),
             record_data    TEXT    NOT NULL,
             zone_id        INTEGER NOT NULL,
             updated_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
             UNIQUE (id, zone_id),
             FOREIGN KEY(zone_id) REFERENCES zones(id)
          );
        SQL
      end
      dir.down do
        execute <<~SQL
          DROP TABLE records
        SQL
      end
    end
  end
end
