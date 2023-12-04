# spec/controllers/my_news_items_controller_spec.rb

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  let(:representative) { FactoryBot.create(:representative) }
  let(:news_item) { FactoryBot.create(:news_item, representative: representative) }

  describe 'GET #new' do
    it 'assigns a new news item to @news_item' do
      get :new, params: { representative_id: representative.id }
      expect(assigns(:news_item)).to be_a_new(NewsItem)
    end

    it 'renders the new template' do
      get :new, params: { representative_id: representative.id }
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested news item to @news_item' do
      get :edit, params: { representative_id: representative.id, id: news_item.id }
      expect(assigns(:news_item)).to eq(news_item)
    end

    it 'renders the edit template' do
      get :edit, params: { representative_id: representative.id, id: news_item.id }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { news_item: FactoryBot.attributes_for(:news_item), representative_id: representative.id } }

      it 'creates a new news item' do
        expect {
          post :create, params: valid_params
        }.to change(NewsItem, :count).by(1)
      end

      it 'redirects to the created news item' do
        post :create, params: valid_params
        expect(response).to redirect_to(representative_news_item_path(representative, NewsItem.last))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { news_item: FactoryBot.attributes_for(:news_item, title: nil), representative_id: representative.id } }

      it 'does not create a new news item' do
        expect {
          post :create, params: invalid_params
        }.not_to change(NewsItem, :count)
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) { { news_item: FactoryBot.attributes_for(:news_item), representative_id: representative.id, id: news_item.id } }

      it 'updates the news item' do
        patch :update, params: valid_params
        news_item.reload
        expect(news_item.title).to eq(valid_params[:news_item][:title])
      end

      it 'redirects to the updated news item' do
        patch :update, params: valid_params
        expect(response).to redirect_to(representative_news_item_path(representative, news_item))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { news_item: FactoryBot.attributes_for(:news_item, title: nil), representative_id: representative.id, id: news_item.id } }

      it 'does not update the news item' do
        patch :update, params: invalid_params
        news_item.reload
        expect(news_item.title).not_to eq(invalid_params[:news_item][:title])
      end

      it 'renders the edit template' do
        patch :update, params: invalid_params
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the news item' do
      delete :destroy, params: { representative_id: representative.id, id: news_item.id }
      expect(NewsItem.exists?(news_item.id)).to be_falsey
    end

    it 'redirects to representative news items path' do
      delete :destroy, params: { representative_id: representative.id, id: news_item.id }
      expect(response).to redirect_to(representative_news_items_path(representative))
    end
  end
end
