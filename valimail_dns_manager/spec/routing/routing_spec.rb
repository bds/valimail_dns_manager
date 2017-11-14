require 'rails_helper'

module ValimailDnsManager
  RSpec.describe 'Routes', type: :routing do
    describe 'Zones resource' do
      let(:name) { 'valimail.com' }

      describe 'creating a zone' do
        # POST 127.0.0.1/zones
        #
        # body: {
        #   name: 'valimail.com'
        # }
        #
        specify do
          expect(
            post: zones_path(name: name)
          ).to route_to(
            controller:  'zones',
            action:      'create',
            format:      :json,
            name:        name,
          )
        end
      end

      describe 'deleting a zone' do
        # DELETE 127.0.0.1/zones/valimail.com
        specify do
          expect(
            delete: zone_path(name: name)
          ).to route_to(
            controller:  'zones',
            action:      'destroy',
            format:      :json,
            name:        name,
          )
        end
      end

      describe 'invalid routes' do
        # DELETE 127.0.0.1/zones/valimail
        specify do
          expect(
            delete: 'zones/valimail'
          ).to_not be_routable
        end
      end
    end

    describe 'Records resource' do
      let(:zone_name)   { 'valimail.com' }
      let(:record_name) { '@www' }
      let(:record_type) { 'A' }
      let(:ttl)         { '600' }

      describe 'listing records' do
        # GET 127.0.0.1/zones/valimail.com/records/
        #
        specify do
          expect(
            get: zone_records_path(
              zone_name:   zone_name,
            )
          ).to route_to(
            controller:  'records',
            action:      'index',
            format:      :json,
            zone_name:   zone_name,
          )
        end
      end

      describe 'creating a record' do
        # POST 127.0.0.1/zones/valimail.com/records
        #
        # body: {
        #   record_name: '@www'
        #   record_type: 'A'
        #   ttl:  '600'
        # }
        #
        specify do
          expect(
            post: zone_records_path(
              zone_name:   zone_name,
              record_type: record_type,
              ttl: ttl,
            )
          ).to route_to(
            controller:  'records',
            action:      'create',
            format:      :json,
            zone_name:   zone_name,
            record_type: record_type,
            ttl:         ttl,
          )
        end
      end

      describe 'deleting a record' do
        # DELETE 127.0.0.1/zones/valimail.com/records/@www
        specify do
          expect(
            delete: zone_record_path(zone_name: zone_name, record_name: record_name)
          ).to route_to(
            controller:  'records',
            action:      'destroy',
            format:      :json,
            zone_name:   zone_name,
            record_name: record_name,
          )
        end
      end

      describe 'retrieving a record' do
        # GET 127.0.0.1/zones/valimail.com/records/@www
        specify do
          expect(
            get: zone_record_path(zone_name: zone_name, record_name: record_name)
          ).to route_to(
            controller:  'records',
            action:      'show',
            format:      :json,
            zone_name:   zone_name,
            record_name: record_name,
          )
        end
      end

      describe 'updating a record' do
        # PUT 127.0.0.1/zones/valimail.com/records/@www
        #
        # body: {
        #   record_name: '@www'
        #   record_type: 'A'
        #   ttl:  '1000'
        # }
        specify do
          expect(
            put: zone_record_path(
              zone_name:   zone_name,
              record_name: record_name,
              record_type: record_type,
              ttl:         ttl,
            )
          ).to route_to(
            controller:  'records',
            action:      'update',
            format:      :json,
            zone_name:   zone_name,
            record_name: record_name,
            record_type: record_type,
            ttl:         ttl,
          )
        end
      end

      describe 'invalid routes' do
        # DELETE 127.0.0.1/zones/valimail.com/records/www
        specify do
          expect(
            delete: 'zones/valimail.com/records/www'
          ).to_not be_routable
        end
      end
    end
  end
end
