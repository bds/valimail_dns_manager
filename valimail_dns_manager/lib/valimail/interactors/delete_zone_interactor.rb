require 'active_support/core_ext/object/blank'

require 'valimail/repositories/zone_repository'
require 'valimail/entities/zone'

module Valimail
  class DeleteZoneInteractor
    def initialize(**options)
      @zone_repository = options[:zone_repository] || ZoneRepository.new
    end

    def self.call(**params)
      new.call(params)
    end

    def call(name:)
      zone_repository.destroy(name: name)
    end

    private

    attr_reader :zone_repository
  end
end
