require 'valimail/interactors/retrieve_record_interactor'

module Valimail
  RSpec.describe RetrieveRecordInteractor do
    subject do
      described_class.new(record_repository: record_repository)
    end
    let(:name)      { '@mail' }
    let(:zone_name) { 'google.com' }

    describe '#call' do
      context 'when a valid record' do
        let(:record_repository) { instance_double('RecordRepository') }

        specify do
          expect(record_repository).to receive(:find).with(
            name:      name,
            zone_name: zone_name
          )

          subject.call(name: name, zone_name: zone_name)
        end
      end
    end
  end
end
