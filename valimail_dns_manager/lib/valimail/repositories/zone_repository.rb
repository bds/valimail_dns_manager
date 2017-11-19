require 'date'
require 'sqlite3'
require 'valimail/entities/zone'

module Valimail
  class ZoneRepository
    def initialize(db: nil, enable_fk_constraints: true)
      @db = db
      @enable_fk_constraints = enable_fk_constraints
    end

    def save(entity)
      db.execute('PRAGMA fks = ON;') if enable_fk_constraints

      if entity.valid?
        statement = 'INSERT INTO zones (id, name) VALUES (?, ?)'
        db_result = db.query(statement, [entity.id, entity.name])

        Result.new(success: true, data: entity)
      else
        Result.new(success: false, data: {errors: entity.errors})
      end
    end

    def update(entity)
      if entity.valid?
        sql = <<-SQL
          UPDATE zones
          SET name = ?
          WHERE id=?
        SQL

        db.execute(sql, [entity.name, entity.id])

        Result.new
      else
        Result.new(success: false, data: {errors: entity.errors})
      end
    end

    def count
      statement = 'SELECT COUNT(*) FROM zones'
      db_result = db.get_first_value(statement).to_i
    end

    def find(name:)
      sql = <<-SQL
        SELECT *
        FROM zones
        WHERE name=?
      SQL

      db.execute(sql, [name]).map do |row|
        attributes = {
          id:         row[0],
          name:       row[1],
          updated_at: DateTime.parse(row[2]),
        }

        Zone.new(**attributes)
      end.first
    end

    def list
      sql = <<-SQL
        SELECT *
        FROM zones
        ORDER BY id DESC
      SQL

      db.execute(sql).map do |row|
        attributes = {
          id:          row[0],
          name:        row[1],
        }

        Zone.new(**attributes)
      end
    end

    def destroy(name:)
      sql = <<-SQL
        DELETE FROM zones
        WHERE name=?
      SQL

      db.execute(sql, [name])
    end

    private

    attr_reader :enable_fk_constraints

    def db
      @db ||= SQLite3::Database.new(Rails.configuration.database_url)
    end
  end
end
