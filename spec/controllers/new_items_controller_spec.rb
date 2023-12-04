# spec/controllers/news_items_controller_spec.rb

require 'rails_helper'

RSpec.describe NewsItemsController, type: :controller do
  let(:representative) { FactoryBot.create(:representative) }
  let(:news_item) { FactoryBot.create(:news_item, representative: representative) }

  describe 'GET #index' do
    it 'assigns @news_items' do
      get :index, params: { representative_id: representative.id }
      expect(assigns(:news_items)).to eq(representative.news_items)
    end

    it 'renders the index template' do
      get :index, params: { representative_id: representative.id }
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'assigns @news_item' do
      get :show, params: { representative_id: representative.id, id: news_item.id }
      expect(assigns(:news_item)).to eq(news_item)
    end

    it 'renders the show template' do
      get :show, params: { representative_id: representative.id, id: news_item.id }
      expect(response).to render_template('show')
    end
  end

  context 'when the representative does not exist' do
    it 'raises ActiveRecord::RecordNotFound for #set_representative' do
      expect do
        get :index, params: { representative_id: 'nonexistent_id' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the news item does not exist' do
    it 'raises ActiveRecord::RecordNotFound for #set_news_item' do
      expect do
        get :show, params: { representative_id: representative.id, id: 'nonexistent_id' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
