require 'valimail/interactors/list_records_interactor'

module Valimail
  RSpec.describe ListRecordInteractor do
    subject do
      described_class.new(record_repository: record_repository)
    end
    let(:zone_name) { 'google.com' }

    describe '#call' do
      context 'when a valid record' do
        let(:record_repository) { instance_double('RecordRepository') }

        specify do
          expect(record_repository).to receive(:list).with(zone_name: zone_name)

          subject.call(zone_name: zone_name)
        end
      end
    end
  end
end
