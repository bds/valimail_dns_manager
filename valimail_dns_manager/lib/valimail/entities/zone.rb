require 'valimail/values/opaque_identifier'
require 'valimail/validators/zone_validator'

module Valimail
  class Zone
    attr_reader :id
    attr_reader :updated_at
    attr_reader :errors

    attr_accessor :name

    def initialize(id: nil, name:, updated_at: nil, validator: nil, options: {})
      @id         = id
      @name       = name
      @updated_at = updated_at
      @validator  = validator
      @errors     = {}
    end

    def id
      @id ||= opaque_identifer
    end

    def cache_key
      id
    end

    def valid?
      result = validator.call(self)

      if result.success?
        @errors = {}
        true
      else
        @errors = result.data
        false
      end
    end

    private

    def validator
      @validator ||= ZoneValidator.new
    end

    def opaque_identifer
      OpaqueIdentifier.new.call
    end
  end
end
