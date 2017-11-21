require 'valimail/presenters/record_presenter'

module Valimail
  class RecordsPresenter
    def initialize(objects)
      @objects = objects
    end

    def as_json(*)
      objects.map { |object| RecordPresenter.new(object) }
    end

    private

    attr_reader :objects
  end
end
