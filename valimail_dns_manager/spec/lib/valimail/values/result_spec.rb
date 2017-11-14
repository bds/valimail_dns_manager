require 'valimail/values/result'

module Valimail
  RSpec.describe Result do
    specify do
      expect(subject).to respond_to(:success?)
      expect(subject).to respond_to(:data)
    end
  end
end
