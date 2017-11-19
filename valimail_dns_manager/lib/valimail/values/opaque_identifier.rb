require 'securerandom'

module Valimail
  class OpaqueIdentifier
    # You can know your PK before insertion, which avoids a round trip DB hit, and
    # simplifies transactional logic in which you need to know the PK before
    # inserting child records using that key as its foreign key (FK)
    def call
      SecureRandom.random_number(2**32..2**63-1)
    end
  end
end
