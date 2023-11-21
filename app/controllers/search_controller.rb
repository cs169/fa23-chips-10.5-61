# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

class SearchController < ApplicationController
  def search
    if params[:county].present?
      handle_county_click(params[:county])
    else
      handle_search(params[:address])
    end
  end

  private

  def handle_search(address)
    service = Google::Apis::CivicinfoV2::CivicInfoService.new
    service.key = Rails.application.credentials[:GOOGLE_API_KEY]
    result = service.representative_info_by_address(address: address)
    @representatives = Representative.civic_api_to_representative_params(result)

    render 'representatives/search'
  end

  def handle_county_click(county)
    @representatives = Representative.where(county: county)

    respond_to do |format|
      format.html { render partial: 'representatives_list', locals: { representatives: @representatives } }
    end
  end
end
