require 'active_support/core_ext/object/blank'

require 'valimail/repositories/record_repository'
require 'valimail/entities/record'

module Valimail
  class DeleteRecordInteractor
    def initialize(**options)
      @record_repository = options[:record_repository] || RecordRepository.new
    end

    def self.call(**params)
      new.call(params)
    end

    def call(name:, zone_name:)
      record_repository.destroy(name: name, zone_name: zone_name)
    end

    private

    attr_reader :record_repository
  end
end
