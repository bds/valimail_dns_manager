require 'valimail/values/record_regex'

module Valimail
  RSpec.describe 'RECORD_REGEX' do
    context 'a valid record name using the root domain' do
      let(:domain_name) { '@valimail.com' }

      specify do
        expect(RECORD_REGEX === domain_name).to be(true)
      end
    end

    context 'a valid record name using a subdomain' do
      let(:domain_name) { '@www' }

      specify do
        expect(RECORD_REGEX === domain_name).to be(true)
      end
    end

    context 'an invalid record name' do
      let(:domain_name) { 'www' }

      specify do
        expect(RECORD_REGEX === domain_name).to be(false)
      end
    end
  end
end

