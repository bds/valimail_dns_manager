require 'valimail/values/ip4_regex'

module Valimail
  RSpec.describe 'IPV4_REGEX' do
    context 'a valid IPv4 address' do
      let(:address) { '127.0.0.1' }

      specify do
        expect(IPV4_REGEX === address).to be(true)
      end
    end

    context 'an invalid IPv4 address' do
      let(:address) { '2001:0db8:85a3:0000:0000:8a2e:0370:7334' }

      specify do
        expect(IPV4_REGEX === address).to be(false)
      end
    end
  end
end

