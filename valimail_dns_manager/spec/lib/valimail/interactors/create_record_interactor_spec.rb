require 'valimail/interactors/create_record_interactor'

module Valimail
  RSpec.describe CreateRecordInteractor do
    subject do
      described_class.new(
        record_repository: record_repository,
        zone_repository:   zone_repository,
      )
    end

    let(:record_type)     { 'A' }
    let(:record_data)     { '127.0.0.1' }
    let(:ttl)             { '600' }
    let(:zone_repository) { instance_double('ZoneRepository', find: zone) }
    let(:zone) {
      instance_double('Zone', id: '123', name: 'google.com')
    }

    describe '#call' do
      context 'when a valid record' do
        let(:name) { '@www' }
        let(:record_repository) {
          instance_double('RecordRepository', save: Result.new)
        }

        specify do
          expect(zone_repository).to receive(:find)
          expect(record_repository).to receive(:save)

          result = subject.call(
            name: name,
            zone_name: zone.name,
            record_type: record_type,
            record_data: record_data,
            ttl: ttl,
          )

          expect(result.success?).to eq(true)
        end
      end

      context 'when a invalid record' do
        let(:name) { 'www' }
        let(:record_repository) {
          instance_double('RecordRepository', save: Result.new(success: false))
        }

        specify do
          expect(record_repository).to receive(:save)

          result = subject.call(
            name: name,
            zone_name: zone.name,
            record_type: record_type,
            record_data: record_data,
            ttl: ttl,
          )

          expect(result.success?).to eq(false)
        end
      end
    end
  end
end
