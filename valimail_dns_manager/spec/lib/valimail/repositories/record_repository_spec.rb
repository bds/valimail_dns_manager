require 'valimail/entities/record'
require 'valimail/entities/zone'
require 'valimail/repositories/record_repository'
require 'valimail/repositories/zone_repository'

module Valimail
  RSpec.describe RecordRepository do
    before do
      zone_repository.save(zone_entity)
    end

    let(:record_entity) {
      Record.new(
        name:        '@aaa',
        record_type: 'A',
        record_data: '127.0.0.1',
        ttl:         '600',
        zone_id:     zone_entity.id,
      )
    }
    let(:zone_entity)     { Zone.new(name: zone_name) }
    let(:zone_name)       { "#{SecureRandom.hex}.com" }
    let(:zone_repository) { ZoneRepository.new }

    describe '#count' do
      specify do
        expect(subject).to respond_to(:count)
      end
    end

    describe "#save" do
      context 'when a valid record_entity' do
        it 'returns a success result' do
          result = subject.save(record_entity)
          expect(result.success?).to eq(true)
        end

        specify do
          expect {
            subject.save(record_entity) 
          }.to change { subject.count }.by(1)
        end
      end

      context 'when an invalid record_entity' do
        let(:record_entity) {
          Record.new(
            name: 'www',
            record_type: 'A',
            ttl: '600',
            zone_id: 'FOOBAR'
          )
        }

        specify do
          result = subject.save(record_entity) 
          expect(result.success?).to eq(false)
        end
      end
    end

    describe "#find" do
      before do
        subject.save(record_entity)
      end

      specify do
        result = subject.find(name: '@aaa', zone_name: zone_name)

        expect(result.data).to be_kind_of(Record)
        expect(result.data.name).to eq('@aaa')
      end
    end

    describe "#list" do
      before do
        subject.save(record_entity)
      end

      specify do
        result = subject.list(zone_name: zone_name)

        expect(result.data).to be_kind_of(Array)
        expect(result.data.first.name).to eq('@aaa')
      end
    end

    describe "#update" do
      before do
        subject.save(record_entity)
      end

      specify do
        record_entity.name = '@www'

        expect {
          subject.update(record_entity)
        }.to change {
          subject.find(name: '@www', zone_name: zone_name).data&.name
        }.from(nil).to('@www')
      end
    end

    describe "#destroy" do
      before do
        subject.save(record_entity)
      end

      specify do
        expect {
          subject.destroy(name: '@aaa', zone_name: zone_name)
        }.to change {
          subject.find(name: '@aaa', zone_name: zone_name).data&.name
        }.from('@aaa').to(nil)
      end
    end
  end
end
