# spec/controllers/user_controller_spec.rb

require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'GET #profile' do
    context 'when the user is logged in' do
      let(:user) { FactoryBot.create(:user) }

      before do
        session[:current_user_id] = user.id
      end

      it 'assigns the requested user to @user' do
        get :profile
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the profile template' do
        get :profile
        expect(response).to render_template('profile')
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the login page' do
        get :profile
        expect(response).to redirect_to(login_path)
      end

      it 'sets a flash notice indicating the need to log in' do
        get :profile
        expect(flash[:notice]).to eq('Please log in to view your profile.')
      end
    end
  end
end
