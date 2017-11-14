require 'active_support/core_ext/object/blank'

require 'valimail/values/domain_regex'
require 'valimail/values/result'

module Valimail
  class ZoneValidator
    attr_reader :errors

    def initialize
      @errors = {}
    end

    def call(entity)
      valid_name?(entity.name)

      if @errors.blank?
        Result.new
      else
        Result.new(success: false, data: @errors)
      end
    end

    def valid_name?(name)
      if name.present? && DOMAIN_REGEX === name
        @errors.delete(:name)
        true
      else
        @errors[:name] = "Invalid name: #{name}"
        false
      end
    end
  end
end
