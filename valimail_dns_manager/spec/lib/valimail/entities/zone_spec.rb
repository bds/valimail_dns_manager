require 'valimail/entities/zone'

module Valimail
  RSpec.describe Zone do
    subject do
      described_class.new(name: name)
    end
    let(:name) { 'valimail.com' }

    specify do
      expect(subject).to respond_to(
        *%i(
          id
          name
          errors
          updated_at
          cache_key
        )
      )
    end

    describe '#valid?' do
      context 'when name is valimail.com' do
        specify do
          expect(subject.valid?).to eq(true)
          expect(subject.errors.size).to eq(0)
        end
      end

      context 'when name is valimail' do
        let(:name) { 'valimail' }

        specify do
          expect(subject.valid?).to eq(false)
          expect(subject.errors.size).to eq(1)
          expect(subject.errors[:name]).to eq("Invalid name: valimail")
        end
      end
    end
  end
end
