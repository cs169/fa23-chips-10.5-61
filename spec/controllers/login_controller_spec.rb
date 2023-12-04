# spec/controllers/login_controller_spec.rb

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET #login' do
    it 'renders the login template' do
      get :login
      expect(response).to render_template('login')
    end

    it 'does not allow access for already logged in users' do
      session[:current_user_id] = user.id
      get :login
      expect(response).to redirect_to(user_profile_path)
    end
  end

  describe 'GET #google_oauth2' do
    it 'redirects to root_url after successful login' do
      allow(controller).to receive(:create_session)
      get :google_oauth2
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'GET #github' do
    it 'redirects to root_url after successful login' do
      allow(controller).to receive(:create_session)
      get :github
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'GET #logout' do
    it 'logs the user out and redirects to root_path' do
      session[:current_user_id] = user.id
      get :logout
      expect(session[:current_user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'private methods' do
    let(:user_info) { { 'provider' => 'google_oauth2', 'uid' => '123', 'info' => { 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com' } } }

    describe '#create_session' do
      it 'assigns session[:current_user_id] with user id' do
        expect(controller).to receive(:find_or_create_user).and_return(user)
        expect(controller).to receive(:redirect_to).with(root_url)
        controller.send(:create_session, :create_google_user)
        expect(session[:current_user_id]).to eq(user.id)
      end
    end

    describe '#find_or_create_user' do
      it 'finds an existing user' do
        allow(User).to receive(:find_by).and_return(user)
        result = controller.send(:find_or_create_user, user_info, :create_google_user)
        expect(result).to eq(user)
      end

      it 'creates a new user if not found' do
        allow(User).to receive(:find_by).and_return(nil)
        expect(controller).to receive(:create_google_user).and_return(user)
        result = controller.send(:find_or_create_user, user_info, :create_google_user)
        expect(result).to eq(user)
      end
    end

    describe '#create_google_user' do
      it 'creates a new user with Google information' do
        allow(User).to receive(:create).and_return(user)
        result = controller.send(:create_google_user, user_info)
        expect(result).to eq(user)
      end
    end

    describe '#create_github_user' do
      it 'creates a new user with GitHub information' do
        allow(User).to receive(:create).and_return(user)
        result = controller.send(:create_github_user, user_info)
        expect(result).to eq(user)
      end
    end

    describe '#already_logged_in' do
      it 'redirects to user profile path if already logged in' do
        session[:current_user_id] = user.id
        allow(controller).to receive(:redirect_to)
        controller.send(:already_logged_in)
        expect(controller).to have_received(:redirect_to).with(user_profile_path)
      end

      it 'does not redirect if not logged in' do
        allow(controller).to receive(:redirect_to)
        controller.send(:already_logged_in)
        expect(controller).not_to have_received(:redirect_to)
      end
    end
  end
end
