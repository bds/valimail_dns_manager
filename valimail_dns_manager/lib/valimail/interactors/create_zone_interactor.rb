require 'valimail/repositories/zone_repository'
require 'valimail/entities/zone'

module Valimail
  class CreateZoneInteractor
    def initialize(**options)
      @zone_repository = options[:zone_repository] || ZoneRepository.new
    end

    def self.call(**params)
      new.call(params)
    end

    def call(name:)
      entity = Zone.new(name: name)
      zone_repository.save(entity)
    end

    private

    attr_reader :zone_repository
  end
end
