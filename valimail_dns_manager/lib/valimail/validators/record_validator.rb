require 'active_support/core_ext/object/blank'

require 'valimail/values/record_regex'
require 'valimail/values/ip4_regex'
require 'valimail/values/domain_regex'
require 'valimail/values/result'

module Valimail
  class RecordValidator
    attr_reader :errors

    def initialize
      @errors = {}
    end

    def call(entity)
      valid_name?(entity.name)
      valid_zone_id?(entity.zone_id)
      valid_record_type?(entity.record_type)
      valid_record_data?(entity.record_type, entity.record_data)
      valid_ttl?(entity.ttl)

      if @errors.blank?
        Result.new
      else
        Result.new(success: false, data: @errors)
      end
    end

    def valid_name?(name)
      if name.present? && RECORD_REGEX === name
        @errors.delete(:name)
        true
      else
        @errors[:name] = "Invalid name: #{name}"
        false
      end
    end

    def valid_record_type?(record_type)
      if record_type.present?
        @errors.delete(:record_type)
        true
      else
        @errors[:record_type] = "Invalid record_type: #{record_type}"
        false
      end
    end

    def valid_record_data?(record_type, record_data)
      if record_type.blank? || record_data.blank?
        @errors[:record_data] = "Invalid record_data: #{record_data}"
        false
      elsif record_type == 'A' && !(IPV4_REGEX === record_data)
        @errors[:record_data] = "Invalid record_data: #{record_data}"
        false
      elsif record_type == 'CNAME' && !(DOMAIN_REGEX === record_data)
        @errors[:record_data] = "Invalid record_data: #{record_data}"
        false
      else
        @errors.delete(:record_data)
        true
      end
    end

    def valid_ttl?(ttl)
      if ttl.present?
        @errors.delete(:ttl)
        true
      else
        @errors[:ttl] = "Invalid ttl: #{ttl}"
        false
      end
    end

    def valid_zone_id?(zone_id)
      if zone_id.present?
        @errors.delete(:zone_id)
        true
      else
        @errors[:zone_id] = "Invalid zone_id: #{zone_id}"
        false
      end
    end
  end
end
