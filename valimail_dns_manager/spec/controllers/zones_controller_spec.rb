require 'rails_helper'
require 'valimail/entities/zone'
require 'valimail/repositories/zone_repository'
require 'json'

module Valimail
  RSpec.describe ZonesController do
    describe "#create" do
      before do
        post :create, {zone_name: zone_name}
      end
      let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

      context 'a valid Zone name' do
        let(:zone_name) { "#{SecureRandom.hex}.com" }
        specify do
          expect(response).to have_http_status(:ok)

          expect(json_response.keys).to match_array(
            %i(
              id
              name
              updated_at
            )
          )
          expect(json_response[:name]).to eq(zone_name)
        end
      end

      context 'a invalid Zone name' do
        let(:zone_name) { "#{SecureRandom.hex}" }
        specify do
          expect(response).to have_http_status(:unprocessable_entity)

          expect(json_response).to eq(
            {
              errors: {
                name: "Invalid name: #{zone_name}"
              }
            }
          )
        end
      end
    end

    describe "#destroy" do
      context 'a valid Zone name' do
        before do
          post :create, {zone_name: zone_name}
        end
        let(:zone_name) { "#{SecureRandom.hex}.com" }

        specify do
          delete :destroy, {name: zone_name}

          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
