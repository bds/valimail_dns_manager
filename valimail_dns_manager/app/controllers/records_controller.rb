require 'valimail/interactors/update_record_interactor'
require 'valimail/interactors/create_record_interactor'
require 'valimail/interactors/retrieve_record_interactor'
require 'valimail/interactors/delete_record_interactor'
require 'valimail/interactors/list_records_interactor'
require 'valimail/presenters/record_presenter'
require 'valimail/presenters/records_presenter'

class RecordsController < ApplicationController
  def create
    result = Valimail::CreateRecordInteractor.call(
      name:        params[:name],
      zone_name:   params[:zone_name],
      record_type: params[:record_type],
      record_data: params[:record_data],
      ttl:         params[:ttl].to_i,
    )

    if result.success?
      render json: Valimail::RecordPresenter.new(result.data)
    else
      render json: result.data, status: :unprocessable_entity
    end
  end

  def index
    result = Valimail::ListRecordInteractor.call(zone_name: params[:zone_name])

    render json: Valimail::RecordsPresenter.new(result.data)
  end

  def show
    result = Valimail::RetrieveRecordInteractor.call(
      name:      params[:record_name],
      zone_name: params[:zone_name],
    )

    if result.success? && result.data
      if stale?(result.data)
        render json: Valimail::RecordPresenter.new(result.data)
      end
    else
      render json: result.data, status: :not_found
    end
  end

  def update
    result = Valimail::UpdateRecordInteractor.call(
      zone_name: params[:zone_name],
      name:      params[:record_name],
      attrs:     params[:data],
    )

    if result.success?
      render json: Valimail::RecordPresenter.new(result.data)
    else
      render json: result.data, status: :unprocessable_entity
    end
  end

   def destroy
     result = Valimail::DeleteRecordInteractor.call(
       name:      params[:record_name],
       zone_name: params[:zone_name],
     )
     render json: {}
   end
end
