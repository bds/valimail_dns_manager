require 'valimail/repositories/record_repository'
require 'valimail/entities/record'
require 'valimail/values/result'

module Valimail
  class UpdateRecordInteractor
    def initialize(**options)
      @record_repository = options[:record_repository] || RecordRepository.new
    end

    def self.call(**params)
      new.call(params)
    end

    def call(name:, zone_name:, attrs: {})
      result = record_repository.find(name: name, zone_name: zone_name)

      if result.success?
        record = result.data
        record.name        = attrs[:name]        if attrs[:name]
        record.record_type = attrs[:record_type] if attrs[:record_type]
        record.record_data = attrs[:record_data] if attrs[:record_data]
        record.ttl         = attrs[:ttl]         if attrs[:ttl]

        record_repository.update(record)
      end
    end

    private

    attr_reader :record_repository
  end
end
