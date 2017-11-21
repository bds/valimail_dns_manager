module Valimail
  class ZonePresenter
    def initialize(object)
      @object = object
    end

    def as_json(*)
      {
        id:   object.id,
        name: object.name,
        updated_at: object.updated_at,
      }
    end

    private

    attr_reader :object
  end
end
