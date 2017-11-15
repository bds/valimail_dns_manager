require 'valimail/repositories/record_repository'
require 'valimail/interactors/delete_record_interactor'
require 'valimail/entities/record'

module Valimail
  RSpec.describe DeleteRecordInteractor do
    subject do
      described_class.new(record_repository: record_repository)
    end
    let(:zone_name) { 'google.com' }

    describe '#call' do
      context 'when a valid name' do
        let(:name)      { '@www' }
        let(:record)    { instance_double('Record') }
        let(:record_repository) { instance_double('RecordRepository') }

        specify do
          expect(record_repository).to receive(:destroy).with(
            name: name,
            zone_name: zone_name,
          )

          subject.call(name: name, zone_name: zone_name)
        end
      end
    end
  end
end
