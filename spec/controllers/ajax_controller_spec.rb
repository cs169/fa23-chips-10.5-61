# spec/controllers/ajax_controller_spec.rb

require 'rails_helper'

RSpec.describe AjaxController, type: :controller do
  describe 'GET #counties' do
    let(:state) { FactoryBot.create(:state, symbol: 'CA') }
    let(:county1) { FactoryBot.create(:county, state: state) }
    let(:county2) { FactoryBot.create(:county, state: state) }

    it 'assigns the requested state to @state' do
      get :counties, params: { state_symbol: 'CA' }
      expect(assigns(:state)).to eq(state)
    end

    it 'renders JSON with the counties of the state' do
      get :counties, params: { state_symbol: 'CA' }
      expected_json = { counties: state.counties.map { |county| { id: county.id, name: county.name } } }.to_json
      expect(response.body).to eq(expected_json)
    end

    context 'when the state symbol is not found' do
      it 'returns a 404 status code' do
        get :counties, params: { state_symbol: 'NonexistentState' }
        expect(response).to have_http_status(404)
      end

      it 'renders JSON with an error message' do
        get :counties, params: { state_symbol: 'NonexistentState' }
        expected_json = { error: 'State not found' }.to_json
        expect(response.body).to eq(expected_json)
      end
    end
  end
end
