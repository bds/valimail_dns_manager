require 'valimail/validators/record_validator'

module Valimail
  RSpec.describe RecordValidator do
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
    end

    describe 'valid_record_type?' do
      context 'when blank' do
        let(:value) { '' }

        specify do
          expect {
            subject.valid_record_type?(value)
          }.to change { subject.errors[:record_type] }.
          from(nil).to("Invalid record_type: ")

          expect(subject.valid_record_type?(value)).to eq(false)
        end
      end

      context 'when nil' do
        let(:value) { nil}

        specify do
          expect {
            subject.valid_record_type?(value)
          }.to change { subject.errors[:record_type] }.
          from(nil).to("Invalid record_type: ")

          expect(subject.valid_record_type?(value)).to eq(false)
        end
      end
    end

    describe 'valid_record_data?' do
      context 'when blank' do
        let(:value)       { '' }
        let(:record_type) { 'A' }

        specify do
          expect {
            subject.valid_record_data?(record_type, value)
          }.to change { subject.errors[:record_data] }.
          from(nil).to("Invalid record_data: ")

          expect(subject.valid_record_data?(record_type, value)).to eq(false)
        end
      end

      context 'when nil' do
        let(:value)       { nil}
        let(:record_type) { 'A' }

        specify do
          expect {
            subject.valid_record_data?(record_type, value)
          }.to change { subject.errors[:record_data] }.
          from(nil).to("Invalid record_data: ")

          expect(subject.valid_record_data?(record_type, value)).to eq(false)
        end
      end

      context 'when record_type is A and record_data is a IP4 address' do
        let(:record_type) { 'A' }
        let(:value)       { '127.0.0.1' }

        specify do
          expect(subject.valid_record_data?(record_type, value)).to eq(true)
        end
      end

      context 'when record_type is CNAME and record_data is a valid domain' do
        let(:record_type) { 'CNAME' }
        let(:value)       { 'google.com' }

        specify do
          expect(subject.valid_record_data?(record_type, value)).to eq(true)
        end
      end

      context 'when record_type is A and record_data is not an IP4 address' do
        let(:record_type) { 'A' }
        let(:value)       { '2001:0db8:85a3:0000:0000:8a2e:0370:7334' }

        specify do
          expect {
            subject.valid_record_data?(record_type, value)
          }.to change { subject.errors[:record_data] }.
          from(nil).to("Invalid record_data: #{value}")

          expect(subject.valid_record_data?(record_type, value)).to eq(false)
        end
      end

      context 'when record_type is CNAME and record_data is not a valid domain' do
        let(:record_type) { 'CNAME' }
        let(:value)       { 'www' }

        specify do
          expect {
            subject.valid_record_data?(record_type, value)
          }.to change { subject.errors[:record_data] }.
          from(nil).to("Invalid record_data: #{value}")

          expect(subject.valid_record_data?(record_type, value)).to eq(false)
        end
      end
    end

    describe 'valid_ttl?' do
      context 'when blank' do
        let(:value) { '' }

        specify do
          expect {
            subject.valid_ttl?(value)
          }.to change { subject.errors[:ttl] }.
          from(nil).to("Invalid ttl: ")

          expect(subject.valid_ttl?(value)).to eq(false)
        end
      end

      context 'when nil' do
        let(:value) { nil }

        specify do
          expect {
            subject.valid_ttl?(value)
          }.to change { subject.errors[:ttl] }.
          from(nil).to("Invalid ttl: ")

          expect(subject.valid_ttl?(value)).to eq(false)
        end
      end
    end

    describe 'valid_zone_id?' do
      context 'when blank' do
        let(:value) { '' }

        specify do
          expect {
            subject.valid_zone_id?(value)
          }.to change { subject.errors[:zone_id] }.
          from(nil).to("Invalid zone_id: ")

          expect(subject.valid_zone_id?(value)).to eq(false)
        end
      end

      context 'when nil' do
        let(:value) { nil }

        specify do
          expect {
            subject.valid_zone_id?(value)
          }.to change { subject.errors[:zone_id] }.
          from(nil).to("Invalid zone_id: ")

          expect(subject.valid_zone_id?(value)).to eq(false)
        end
      end
    end
  end
end
