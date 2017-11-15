require 'valimail/interactors/create_zone_interactor'

module Valimail
  RSpec.describe CreateZoneInteractor do
    subject do
      described_class.new(zone_repository: zone_repository)
    end

    describe '#call' do
      context 'when a valid name' do
        let(:name) { 'google.com' }
        let(:zone_repository) {
          instance_double('ZoneRepository', save: Result.new)
        }

        specify do
          expect(zone_repository).to receive(:save)

          result = subject.call(name: name)

          expect(result.success?).to eq(true)
        end
      end

      context 'when a invalid zone' do
        let(:name) { 'www' }
        let(:zone_repository) { nil }

        specify do
          result = subject.call(name: name)

          expect(result.success?).to eq(false)
          expect(result.data[:errors]).to eq({name: 'Invalid name: www'})
        end
      end
    end
  end
end
