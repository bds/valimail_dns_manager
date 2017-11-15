require 'valimail/values/opaque_identifier'
require 'valimail/validators/record_validator'

module Valimail
  class Record
    attr_reader :id
    attr_reader :zone_id
    attr_reader :updated_at
    attr_reader :errors

    attr_accessor :name
    attr_accessor :record_type
    attr_accessor :record_data
    attr_accessor :ttl

    # Record.new(
    #   name:        'google.com',
    #   record_type: 'A'
    #   record_data: '127.0.0.1',
    #   ttl: '600',
    # )
    #
    # If record_type if 'A' record data must be a valid IPv4 address
    # If record_type is CNAME record data must then be a valid domain name
    #
    def initialize(options: {}, **attributes)
      @name             = attributes[:name]
      @record_type      = attributes[:record_type]
      @record_data      = attributes[:record_data]
      @ttl              = attributes[:ttl]
      @zone_id          = attributes[:zone_id]
      @updated_at       = attributes[:updated_at] || nil
      @id               = attributes[:id]         || nil
      @validator        = attributes[:validator]  || nil

      @errors           = {}
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
      @validator ||= RecordValidator.new
    end

    def opaque_identifer
      OpaqueIdentifier.new.call
    end
  end
end
