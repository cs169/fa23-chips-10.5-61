# spec/controllers/search_controller_spec.rb

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    context 'with a valid address' do
      let(:valid_address) { '1600 Amphitheatre Parkway, Mountain View, CA' }

      it 'assigns @representatives' do
        allow_any_instance_of(Google::Apis::CivicinfoV2::CivicInfoService)
          .to receive(:representative_info_by_address)
          .and_return(valid_civic_info_response)

        get :search, params: { address: valid_address }

        expect(assigns(:representatives)).not_to be_nil
      end

      it 'renders the search template' do
        allow_any_instance_of(Google::Apis::CivicinfoV2::CivicInfoService)
          .to receive(:representative_info_by_address)
          .and_return(valid_civic_info_response)

        get :search, params: { address: valid_address }

        expect(response).to render_template('representatives/search')
      end
    end

    context 'with an invalid address' do
      let(:invalid_address) { 'Invalid Address' }

      it 'does not assign @representatives' do
        allow_any_instance_of(Google::Apis::CivicinfoV2::CivicInfoService)
          .to receive(:representative_info_by_address)
          .and_return(nil)

        get :search, params: { address: invalid_address }

        expect(assigns(:representatives)).to be_nil
      end

      it 'renders the search template' do
        allow_any_instance_of(Google::Apis::CivicinfoV2::CivicInfoService)
          .to receive(:representative_info_by_address)
          .and_return(nil) # Simulate an invalid response

        get :search, params: { address: invalid_address }

        expect(response).to render_template('representatives/search')
      end
    end
  end

end
