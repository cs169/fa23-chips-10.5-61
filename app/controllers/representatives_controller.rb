# frozen_string_literal: true

class RepresentativesController < ApplicationController
  before_action :find_representative, only: [:show, :edit, :update, :destroy]
  def index
    @representatives = Representative.all
  end

  def show
    # Additional logic for showing a representative
  end

  def new
    @representative = Representative.new
  end

  def create
    @representative = Representative.new(representative_params)

    if @representative.save
      redirect_to representative_path(@representative), notice: 'Representative was successfully created.'
    else
      render :new
    end
  end

  def search
      address = params[:address]
      service = Google::Apis::CivicinfoV2::CivicInfoService.new
      service.key = Rails.application.credentials[:GOOGLE_API_KEY]
      # byebug
      result = service.representative_info_by_address(address: address)
      @representatives = Representative.civic_api_to_representative_params(result)
  
      render 'representatives/search'
  end

  def edit
    # Additional logic for editing a representative
  end

  def update
    if @representative.update(representative_params)
      redirect_to representative_path(@representative), notice: 'Representative was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @representative.destroy
    redirect_to representatives_path, notice: 'Representative was successfully destroyed.'
  end

  private

  def find_representative
    @representative = Representative.find(params[:id])
  end

  def representative_params
    params.require(:representative).permit(:name, :ocdid, :title, :street, :city, :state, :zip, :party, :photo)
  end
end
