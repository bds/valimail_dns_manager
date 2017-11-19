require 'valimail/entities/zone'
require 'valimail/repositories/zone_repository'

module Valimail
  RSpec.describe ZoneRepository do
    let(:zone_entity) {
      Zone.new(name: zone_name)
    }
    let(:zone_name) { "#{SecureRandom.hex}.com" }

    describe '#count' do
      specify do
        expect(subject).to respond_to(:count)
      end
    end

    describe "#save" do
      context 'when a valid zone_entity' do
        it 'returns a success result' do
          result = subject.save(zone_entity)
          expect(result.success?).to eq(true)
        end

        specify do
          expect {
            subject.save(zone_entity) 
          }.to change { subject.count }.by(1)
        end
      end

      context 'when an invalid zone_entity' do
        let(:zone_entity) { Zone.new( name: 'valimail') }

        specify do
          result = subject.save(zone_entity) 
          expect(result.success?).to eq(false)
        end
      end
    end

    describe "#find" do
      before do
        subject.save(zone_entity)
      end

      specify do
        record = subject.find(name: zone_name)

        expect(record).to be_kind_of(Zone)
        expect(record.name).to eq(zone_name)
      end
    end

    describe "#list" do
      before do
        subject.save(zone_entity)
      end

      specify do
        zones = subject.list

        expect(zones).to be_kind_of(Array)
        expect(zones.first).to be_kind_of(Zone)
      end
    end

    describe "#update" do
      before do
        subject.save(zone_entity)
      end
      let(:zone_name_new) { "#{SecureRandom.hex}.com" }

      specify do
        zone_entity.name = zone_name_new

        expect {
          subject.update(zone_entity)
        }.to change {
          subject.find(name: zone_name_new)&.name
        }.from(nil).to(zone_name_new)
      end
    end

    describe "#destroy" do
      before do
        subject.save(zone_entity)
      end

      specify do
        expect {
          subject.destroy(name: zone_name)
        }.to change {
          subject.find(name: zone_name)&.name
        }.from(zone_name).to(nil)
      end
    end
  end
end
