require 'valimail/interactors/create_zone_interactor'

class ZonesController < ApplicationController
  def create
    render json: {name: 'valimail.com'}
  end

  def destroy
    render json: {}
  end
end
