# spec/controllers/map_controller_spec.rb

require 'rails_helper'

RSpec.describe MapController, type: :controller do
  let(:state) { FactoryBot.create(:state, symbol: 'CA') }
  let(:county) { FactoryBot.create(:county, state: state) }

  describe 'GET #index' do
    it 'assigns all states to @states' do
      get :index
      expect(assigns(:states)).to eq(State.all)
    end

    it 'assigns states by FIPS code to @states_by_fips_code' do
      get :index
      expect(assigns(:states_by_fips_code)).to eq(State.all.index_by(&:std_fips_code))
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #state' do
    it 'assigns the requested state to @state' do
      get :state, params: { state_symbol: 'CA' }
      expect(assigns(:state)).to eq(state)
    end

    it 'handles state not found and redirects to root path' do
      allow(State).to receive(:find_by).and_return(nil)
      get :state, params: { state_symbol: 'NonexistentState' }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("State 'NONEXISTENTSTATE' not found.")
    end

    it 'assigns county details to @county_details' do
      get :state, params: { state_symbol: 'CA' }
      expect(assigns(:county_details)).to eq(state.counties.index_by(&:std_fips_code))
    end

    it 'renders the state template' do
      get :state, params: { state_symbol: 'CA' }
      expect(response).to render_template('state')
    end
  end

  describe 'GET #county' do
    it 'assigns the requested state to @state' do
      get :county, params: { state_symbol: 'CA' }
      expect(assigns(:state)).to eq(state)
    end

    it 'handles state not found and redirects to root path' do
      allow(State).to receive(:find_by).and_return(nil)
      get :county, params: { state_symbol: 'NonexistentState' }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("State 'NONEXISTENTSTATE' not found.")
    end

    it 'assigns the requested county to @county' do
      get :county, params: { state_symbol: 'CA', std_fips_code: county.std_fips_code }
      expect(assigns(:county)).to eq(county)
    end

    it 'handles county not found and redirects to root path' do
      allow(County).to receive(:find_by).and_return(nil)
      get :county, params: { state_symbol: 'CA', std_fips_code: 'NonexistentCounty' }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("County with code 'NONEXISTENTCOUNTY' not found for CA")
    end

    it 'assigns county details to @county_details' do
      get :county, params: { state_symbol: 'CA', std_fips_code: county.std_fips_code }
      expect(assigns(:county_details)).to eq(state.counties.index_by(&:std_fips_code))
    end

    it 'renders the county template' do
      get :county, params: { state_symbol: 'CA', std_fips_code: county.std_fips_code }
      expect(response).to render_template('county')
    end
  end

  describe 'private methods' do
    describe '#handle_state_not_found' do
      it 'redirects to root path with alert message' do
        allow(controller).to receive(:redirect_to)
        controller.send(:handle_state_not_found)
        expect(controller).to have_received(:redirect_to).with(root_path)
        expect(flash[:alert]).to eq("State 'NONEXISTENTSTATE' not found.")
      end
    end

    describe '#handle_county_not_found' do
      it 'redirects to root path with alert message' do
        allow(controller).to receive(:redirect_to)
        controller.send(:handle_county_not_found)
        expect(controller).to have_received(:redirect_to).with(root_path)
        expect(flash[:alert]).to eq("County with code 'NONEXISTENTCOUNTY' not found for CA")
      end
    end

    describe '#get_requested_county' do
      it 'finds the requested county' do
        allow(County).to receive(:find_by).and_return(county)
        result = controller.send(:get_requested_county, state.id)
        expect(result).to eq(county)
      end
    end
  end
end
