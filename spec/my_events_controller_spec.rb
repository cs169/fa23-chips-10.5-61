# spec/controllers/my_events_controller_spec.rb

require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do
  let(:event) { FactoryBot.create(:event) }

  describe 'GET #new' do
    it 'assigns a new event to @event' do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested event to @event' do
      get :edit, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
    end

    it 'renders the edit template' do
      get :edit, params: { id: event.id }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { event: FactoryBot.attributes_for(:event) } }

      it 'creates a new event' do
        expect {
          post :create, params: valid_params
        }.to change(Event, :count).by(1)
      end

      it 'redirects to the events path' do
        post :create, params: valid_params
        expect(response).to redirect_to(events_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { event: FactoryBot.attributes_for(:event, name: nil) } }

      it 'does not create a new event' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Event, :count)
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) { { event: FactoryBot.attributes_for(:event), id: event.id } }

      it 'updates the event' do
        patch :update, params: valid_params
        event.reload
        expect(event.name).to eq(valid_params[:event][:name])
      end

      it 'redirects to the events path' do
        patch :update, params: valid_params
        expect(response).to redirect_to(events_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { event: FactoryBot.attributes_for(:event, name: nil), id: event.id } }

      it 'does not update the event' do
        patch :update, params: invalid_params
        event.reload
        expect(event.name).not_to eq(invalid_params[:event][:name])
      end

      it 'renders the edit template' do
        patch :update, params: invalid_params
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the event' do
      delete :destroy, params: { id: event.id }
      expect(Event.exists?(event.id)).to be_falsey
    end

    it 'redirects to events path' do
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(events_path)
    end
  end
end
