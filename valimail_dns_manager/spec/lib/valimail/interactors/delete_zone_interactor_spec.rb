require 'valimail/repositories/zone_repository'
require 'valimail/interactors/delete_zone_interactor'
require 'valimail/entities/zone'

module Valimail
  RSpec.describe DeleteZoneInteractor do
    subject do
      described_class.new(zone_repository: zone_repository)
    end

    let(:zone_repository) { instance_double('ZoneRepository') }

    describe '#call' do
      context 'when a valid name' do
        let(:name) { 'google.com' }
        let(:zone) { instance_double('Zone') }

        specify do
          expect(zone_repository).to receive(:destroy).with(name: name)

          result = subject.call(name: name)
        end
      end
    end
  end
end
