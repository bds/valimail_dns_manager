require 'valimail/values/domain_regex'
require 'valimail/values/record_regex'

Rails.application.routes.draw do
  defaults format: :json  do
    resources :zones,
      only: [:create, :destroy],
      param: :name,
      constraints: {
        name: Valimail::DOMAIN_REGEX
      },
      format: false do

      resources :records,
        only: [:create, :destroy, :show, :index, :update],
        param: :record_name,
        constraints: {
          record_name: Valimail::RECORD_REGEX
        },
        format: false  do
      end
    end
  end
end
