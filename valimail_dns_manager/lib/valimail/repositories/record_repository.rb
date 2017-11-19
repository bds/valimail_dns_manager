require 'date'
require 'sqlite3'
require 'valimail/entities/record'

module Valimail
  class RecordRepository
    def initialize(db: nil, enable_fk_constraints: true)
      @db = db
      @enable_fk_constraints = enable_fk_constraints
    end

    def save(entity)
      db.execute('PRAGMA fks = ON;') if enable_fk_constraints

      if entity.valid?
        sql = <<-SQL
          INSERT INTO records (id, name, record_type, record_data, ttl, zone_id)
          VALUES (?, ?, ?, ?, ?, ?)
        SQL

        result = db.query(sql, [
            entity.id,
            entity.name,
            entity.record_type,
            entity.record_data,
            entity.ttl,
            entity.zone_id,
          ]
        )

        Result.new(success: true, data: entity)
      else
        Result.new(success: false, data: {errors: entity.errors})
      end
    end

    def update(entity)
      if entity.valid?
        sql = <<-SQL
          UPDATE records
          SET name = ?,
              record_type = ?,
              record_data = ?,
              ttl         = ?,
              updated_at  = ?
          WHERE id=? AND zone_id=?
        SQL

        result = db.query(sql, [
            entity.name,
            entity.record_type,
            entity.record_data,
            entity.ttl,
            DateTime.now.iso8601,
            entity.id,
            entity.zone_id,
          ]
        )

        Result.new(data: entity)
      else
        Result.new(success: false, data: {errors: entity.errors})
      end
    end

    def count
      sql = <<-SQL
        SELECT COUNT(*)
        FROM records
      SQL

      db.get_first_value(sql).to_i
    end

    def find(name:, zone_name:)
      sql = <<-SQL
        SELECT records.id,
               records.name,
               records.ttl,
               records.record_type,
               records.record_data,
               records.zone_id,
               records.updated_at
        FROM records
        LEFT JOIN zones ON zones.id = records.zone_id
        WHERE records.name=? AND zones.name=?
      SQL

      record = db.execute(sql, [name, zone_name]).map do |row|
        attributes = {
          id:          row[0],
          name:        row[1],
          ttl:         Integer(row[2]),
          record_type: row[3],
          record_data: row[4],
          zone_id:     row[5],
          updated_at:  DateTime.parse(row[6]),
        }

        Record.new(**attributes)
      end.first

      if record.present?
        Result.new(data: record)
      else
        Result.new
      end
    end

    def list(zone_name:)
      sql = <<-SQL
        SELECT records.id,
               records.name,
               records.ttl,
               records.record_type,
               records.record_data,
               records.zone_id,
               records.updated_at
        FROM records
        LEFT JOIN zones ON zones.id = records.zone_id
        WHERE zones.name=?
      SQL

      records = db.execute(sql, [zone_name]).map do |row|
        attributes = {
          id:          row[0],
          name:        row[1],
          ttl:         Integer(row[2]),
          record_type: row[3],
          record_data: row[4],
          zone_id:     row[5],
          updated_at:  DateTime.parse(row[6]),
        }

        Record.new(**attributes)
      end

      if records.present?
        Result.new(data: records)
      else
        Result.new
      end
    end

    def destroy(name:, zone_name:)
      sql = <<-SQL
        DELETE FROM records
        WHERE records.id in (
          SELECT records.id
          FROM records
          LEFT JOIN zones ON zones.id = records.zone_id
          WHERE records.name=? AND zones.name=?
        )
      SQL

      db.execute(sql, [name, zone_name])
    end

    private

    attr_reader :enable_fk_constraints

    def db
      @db ||= SQLite3::Database.new(Rails.configuration.database_url)
    end
  end
end
