require 'valimail/repositories/record_repository'

module Valimail
  class ListRecordInteractor
    def initialize(**options)
      @record_repository = options[:record_repository] || RecordRepository.new
    end

    def self.call(**params)
      new.call(params)
    end

    def call(zone_name:)
      record_repository.list(zone_name: zone_name)
    end

    private

    attr_reader :record_repository
  end
end
