require 'valimail/validators/zone_validator'

module Valimail
  RSpec.describe ZoneValidator do
    describe 'valid_name?' do
      context 'when blank' do
        let(:value) { '' }

        specify do
          expect{subject.valid_name?(value)}.to change { subject.errors[:name] }.
            from(nil).to("Invalid name: ")

          expect(subject.valid_name?(value)).to eq(false)
        end
      end

      context 'when nil' do
        let(:value) { nil }

        specify do
          expect{subject.valid_name?(value)}.to change { subject.errors[:name] }.
            from(nil).to("Invalid name: ")

          expect(subject.valid_name?(value)).to eq(false)
        end
      end

      context 'when valimail.com' do
        let(:value) { 'valimail.com' }

        specify do
          expect(subject.valid_name?(value)).to eq(true)
        end
      end

      context 'when valimail' do
        let(:value) { 'valimail' }

        specify do
          expect{subject.valid_name?(value)}.to change { subject.errors[:name] }.
            from(nil).to("Invalid name: valimail")

          expect(subject.valid_name?(value)).to eq(false)
        end
      end
    end
  end
end
