module Valimail
  class Result
    attr_reader :data

    def initialize(success: true, data: nil)
      @success = success
      @data    = data
    end

    def success?
      @success ? true : false
    end
  end
end
