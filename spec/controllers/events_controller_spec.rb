# spec/controllers/events_controller_spec.rb

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:state) { FactoryBot.create(:state, symbol: 'CA') }
  let(:county) { FactoryBot.create(:county, state: state) }
  let(:event) { FactoryBot.create(:event, county: county) }

  describe 'GET #index' do
    context 'without filtering' do
      it 'assigns all events to @events' do
        get :index
        expect(assigns(:events)).to eq(Event.all)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end
    end

    context 'with state-only filtering' do
      it 'assigns filtered events to @events' do
        get :index, params: { 'filter-by' => 'state-only', 'state' => 'CA' }
        expect(assigns(:events)).to eq(Event.where(county: state.counties))
      end

      it 'renders the index template' do
        get :index, params: { 'filter-by' => 'state-only', 'state' => 'CA' }
        expect(response).to render_template('index')
      end
    end

    context 'with county filtering' do
      it 'assigns filtered events to @events' do
        get :index, params: { 'filter-by' => 'county', 'state' => 'CA', 'county' => county.fips_code }
        expect(assigns(:events)).to eq(Event.where(county: county))
      end

      it 'renders the index template' do
        get :index, params: { 'filter-by' => 'county', 'state' => 'CA', 'county' => county.fips_code }
        expect(response).to render_template('index')
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested event to @event' do
      get :show, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
    end

    it 'renders the show template' do
      get :show, params: { id: event.id }
      expect(response).to render_template('show')
    end
  end
end
