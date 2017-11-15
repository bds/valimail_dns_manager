require 'valimail/interactors/update_record_interactor'

module Valimail
  RSpec.describe UpdateRecordInteractor do
    subject do
      described_class.new(record_repository: record_repository)
    end

    let(:zone_name)       { 'google.com' }
    let(:record_type)     { 'A' }
    let(:record_data)     { '127.0.0.1' }
    let(:ttl)             { '600' }

    describe '#call' do
      context 'when a valid record' do
        let(:name) { '@www' }
        let(:record_repository) {
          instance_double('RecordRepository', find: Result.new(data: record))
        }
        let(:record) { instance_double('Record', ttl: ttl) }

        specify do
          expect(record).to receive(:ttl=)
          expect(record_repository).to receive(:update).with(record) { Result.new }

          result = subject.call(
            name: name,
            zone_name: zone_name,
            attrs: { ttl: ttl },
          )

          expect(result.success?).to eq(true)
        end
      end

      context 'when updating record with invalid data' do
        let(:name) { 'www' }
        let(:record_repository) {
          instance_double('RecordRepository', find: Result.new(data: record))
        }
        let(:record) { instance_double('Record', ttl: ttl) }

        specify do
          expect(record).to receive(:name=)
          expect(record_repository).to receive(:update).with(record)

          result = subject.call(
            name: name,
            zone_name: zone_name,
            attrs: { name: 'foo' },
          )
        end
      end
    end
  end
end
