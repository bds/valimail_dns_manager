require 'valimail/values/domain_regex'

module Valimail
  RSpec.describe 'DOMAIN_REGEX' do
    context 'a valid domain name' do
      let(:domain_name) { 'valimail.com' }

      specify do
        expect(DOMAIN_REGEX === domain_name).to be(true)
      end
    end

    context 'an invalid domain name' do
      let(:domain_name) { 'valimail' }

      specify do
        expect(DOMAIN_REGEX === domain_name).to be(false)
      end
    end
  end
end

