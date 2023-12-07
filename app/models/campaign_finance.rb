# frozen_string_literal: true

class CampaignFinance < ApplicationRecord
  def self.fetch_top_20_candidates(selected_cycle, selected_category, api_key='9lcjslvwVjbqtX0KcQQ3W9rFm316caQQ2T89n4xA')
    connection = Faraday.new do |conn|
      conn.url_prefix = 'https://api.propublica.org/campaign-finance/v1/'
      conn.headers['X-API-Key'] = api_key
      conn.adapter Faraday.default_adapter
    end
    response = connection.get("#{selected_cycle}/candidates/leaders/#{selected_category}.json")
    parsed_data = JSON.parse(response.body)
    candidates = parsed_data['results']
    top_20_candidates = candidates&.first(20)
    top_20_candidates || []
  end
end
