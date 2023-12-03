# spec/controllers/representatives_controller_spec.rb

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @representatives' do
      representative = FactoryBot.create(:representative)
      get :index
      expect(assigns(:representatives)).to eq([representative])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      representative = FactoryBot.create(:representative)
      get :show, params: { id: representative.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new representative' do
      get :new
      expect(assigns(:representative)).to be_a_new(Representative)
    end
  end
  
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new representative' do
        expect {
          post :create, params: { representative: FactoryBot.attributes_for(:representative) }
        }.to change(Representative, :count).by(1)
      end

      it 'redirects to the created representative' do
        post :create, params: { representative: FactoryBot.attributes_for(:representative) }
        expect(response).to redirect_to(representative_path(Representative.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new representative' do
        expect {
          post :create, params: { representative: FactoryBot.attributes_for(:representative, name: nil) }
        }.not_to change(Representative, :count)
      end

      it 'renders the new template' do
        post :create, params: { representative: FactoryBot.attributes_for(:representative, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end
end
