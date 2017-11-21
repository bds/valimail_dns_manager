require 'valimail/interactors/create_zone_interactor'
require 'valimail/interactors/delete_zone_interactor'
require 'valimail/presenters/zone_presenter'

class ZonesController < ApplicationController
  def create
    result = Valimail::CreateZoneInteractor.call(name: params[:zone_name])

    if result.success?
      render json: Valimail::ZonePresenter.new(result.data)
    else
      render json: result.data, status: :unprocessable_entity
    end
  end

  def destroy
    result = Valimail::DeleteZoneInteractor.call(name: params[:zone_name])
    render json: {}
  end
end
