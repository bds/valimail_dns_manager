require 'rails_helper'
require 'valimail/entities/record'
require 'valimail/repositories/record_repository'
require 'valimail/repositories/zone_repository'
require 'json'

module Valimail
  RSpec.describe RecordsController do
    let(:record_name)   { "@www" }
    let(:record_type)   { "A" }
    let(:record_data)   { "127.0.0.1" }
    let(:zone)          { Zone.new(name: zone_name) }
    let(:zone_name)     { "#{SecureRandom.hex}.com" }
    let(:ttl)           { 600 }
    let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

    describe "#create" do
      before do
        ZoneRepository.new.save(zone)

        post :create, {
          name: record_name,
          zone_name: zone_name,
          record_type: record_type,
          record_data: record_data,
          ttl: ttl,
        }
      end

      context 'a valid Record name' do
        specify do
          expect(response).to have_http_status(:ok)
          expect(json_response.keys).to match_array(
            %i(
              id
              name
              record_type
              record_data
              ttl
              updated_at
            )
          )
          expect(
            json_response.slice(:name, :record_type, :record_data, :ttl)
          ).to eq(
            {
              name: record_name,
              record_type: record_type,
              record_data: record_data,
              ttl: ttl,
            }
          )
        end
      end

      context 'a invalid Record name' do
        let(:record_name) { "#{SecureRandom.hex}" }
        specify do
          expect(response).to have_http_status(:unprocessable_entity)

          expect(json_response).to eq(
            {
              errors: {
                name: "Invalid name: #{record_name}"
              }
            }
          )
        end
      end
    end

    describe "#destroy" do
      context 'a valid Record name' do
        before do
          ZoneRepository.new.save(zone)

          post :create, {
            name: record_name,
            zone_name: zone_name,
            record_type: record_type,
            record_data: record_data,
            ttl: ttl,
          }
        end

        specify do
          delete :destroy, {
            zone_name:   zone_name,
            record_name: record_name,
          }

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#index" do
      context 'a valid Zone name' do
        before do
          ZoneRepository.new.save(zone)

          post :create, {
            name: record_name,
            zone_name: zone_name,
            record_type: record_type,
            record_data: record_data,
            ttl: ttl,
          }
        end

        specify do
          get :index, { zone_name: zone_name }

          expect(response).to have_http_status(:ok)
          expect(json_response.first.keys).to match_array(
            %i(
              id
              name
              record_type
              record_data
              ttl
              updated_at
            )
          )
          expect(
            json_response.first.slice(:name, :record_type, :record_data, :ttl)
          ).to eq(
            {
              name: record_name,
              record_type: record_type,
              record_data: record_data,
              ttl: ttl,
            }
          )
        end
      end
    end

    describe "#show" do
      context 'a valid Zone name' do
        before do
          ZoneRepository.new.save(zone)

          post :create, {
            name: record_name,
            zone_name: zone_name,
            record_type: record_type,
            record_data: record_data,
            ttl: ttl,
          }
        end

        specify do
          get :show, {
            zone_name:   zone_name,
            record_name: record_name,
          }

          expect(response).to have_http_status(:ok)
          expect(json_response.keys).to match_array(
            %i(
              id
              name
              record_type
              record_data
              ttl
              updated_at
            )
          )
          expect(
            json_response.slice(:name, :record_type, :record_data, :ttl)
          ).to eq(
            {
              name: record_name,
              record_type: record_type,
              record_data: record_data,
              ttl: ttl,
            }
          )
        end
      end

      context 'a Record that does not exist' do
        before do
          ZoneRepository.new.save(zone)
        end

        specify do
          get :show, {
            zone_name:   zone_name,
            record_name: record_name,
          }

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "#update" do
      context 'a valid Zone name' do
        before do
          result = ZoneRepository.new.save(zone)

          post :create, {
            name: record_name,
            zone_name: zone_name,
            record_type: record_type,
            record_data: record_data,
            ttl: ttl,
          }
          puts response.body
        end

        specify do
          patch :update, {
            zone_name:   zone_name,
            record_name: record_name,
            data: {
              name: '@mail',
              ttl:  '5',
            }
          }

          expect(response).to have_http_status(:ok)
          expect(json_response.keys).to match_array(
            %i(
              id
              name
              record_type
              record_data
              ttl
              updated_at
            )
          )
          expect(
            json_response.slice(:name, :record_type, :record_data, :ttl)
          ).to eq(
            {
              name: '@mail',
              record_type: record_type,
              record_data: record_data,
              ttl: '5',
            }
          )
        end
      end

      context 'when updating record with invalid data' do
        before do
          result = ZoneRepository.new.save(zone)

          post :create, {
            name: record_name,
            zone_name: zone_name,
            record_type: record_type,
            record_data: record_data,
            ttl: ttl,
          }
          puts response.body
        end

        specify do
          patch :update, {
            zone_name:   zone_name,
            record_name: record_name,
            data: {
              name: 'mail',
              ttl:  '5',
            }
          }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response).to eq(
            {
              errors: {
                name: "Invalid name: mail"
              }
            }
          )
        end
      end
    end
  end
end
