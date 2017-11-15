require 'valimail/entities/record'

module Valimail
  RSpec.describe Record do
    specify do
      expect(subject).to respond_to(
        *%i(
          id
          name
          record_type
          record_data
          ttl
          zone_id
          errors
          updated_at
          cache_key
        )
      )
    end

    describe '#valid?' do
      subject do
        described_class.new(
          name: name,
          ttl:  '600',
          record_type: 'A',
          record_data: '127.0.0.1',
          zone_id: '123',
        )
      end

      context 'when name is @www' do
        let(:name) { '@www' }

        specify do
          expect(subject.valid?).to eq(true)
          expect(subject.errors.size).to eq(0)
        end
      end

      context 'when name is www' do
        let(:name) { 'www' }

        specify do
          expect(subject.valid?).to eq(false)
          expect(subject.errors.size).to eq(1)
          expect(subject.errors[:name]).to eq("Invalid name: www")
        end
      end
    end
  end
end
