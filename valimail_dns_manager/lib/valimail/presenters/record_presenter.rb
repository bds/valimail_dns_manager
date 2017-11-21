module Valimail
  class RecordPresenter
    def initialize(object)
      @object = object
    end

    def as_json(*)
      {
        id:           object.id,
        name:         object.name,
        record_type:  object.record_type,
        record_data:  object.record_data,
        ttl:          object.ttl,
        updated_at:   object.updated_at,
      }
    end

    private

    attr_reader :object
  end
end
