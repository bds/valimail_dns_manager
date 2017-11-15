require 'valimail/repositories/record_repository'

module Valimail
  class RetrieveRecordInteractor
    def initialize(**options)
      @record_repository = options[:record_repository] || RecordRepository.new
    end

    def self.call(**params)
      new.call(params)
    end

    def call(name:, zone_name:)
      record_repository.find(name: name, zone_name: zone_name)
    end

    private

    attr_reader :record_repository
  end
end
