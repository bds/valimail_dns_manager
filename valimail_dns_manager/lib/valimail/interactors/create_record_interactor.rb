require 'valimail/repositories/zone_repository'
require 'valimail/repositories/record_repository'
require 'valimail/entities/record'

module Valimail
  class CreateRecordInteractor
    def initialize(**options)
      @record_repository = options[:record_repository] || RecordRepository.new
      @zone_repository   = options[:zone_repository]   || ZoneRepository.new
    end

    def self.call(**params)
      new.call(params)
    end

    def call(name:, record_type:, record_data:, ttl:, zone_name:)
      zone = zone_repository.find(name: zone_name)

      if zone.present?
        record = Record.new(
          name:        name,
          record_type: record_type,
          record_data: record_data,
          ttl:         ttl,
          zone_id:     zone.id,
        )

        record_repository.save(record)
      end
    end

    private

    attr_reader :record_repository
    attr_reader :zone_repository
  end
end
