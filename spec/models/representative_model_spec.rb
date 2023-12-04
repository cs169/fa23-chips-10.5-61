# spec/models/representative_model/spec.rb

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    it 'creates or updates representatives based on civic API data' do
      rep_info = double('rep_info', officials: [], offices: [])

      official_data = {
        name: 'John Doe',
        address: [double('address', line1: '123 Main St', city: 'Cityville', state: 'ST', zip: '12345')],
        party: 'Independent',
        photo_url: 'http://example.com/photo.jpg'
      }

      allow(rep_info.officials).to receive(:each_with_index).and_yield(official_data, 0)
      allow(rep_info.offices).to receive(:each)

      representatives = Representative.civic_api_to_representative_params(rep_info)
      expect(representatives.count).to eq(1)
      expect(representatives.first.name).to eq('John Doe')
      expect(representatives.first.ocdid).to eq('')
      expect(representatives.first.title).to eq('')
      expect(representatives.first.street).to eq('123 Main St')
      expect(representatives.first.city).to eq('Cityville')
      expect(representatives.first.state).to eq('ST')
      expect(representatives.first.zip).to eq('12345')
      expect(representatives.first.party).to eq('Independent')
      expect(representatives.first.photo).to eq('http://example.com/photo.jpg')
    end
  end
end
