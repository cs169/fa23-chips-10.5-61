# spec/models/representative_model/spec.rb

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    it 'creates or updates representatives based on civic API data' do
      rep_info = double('rep_info', officials: [], offices: [])

      official_data_1 = {
        name: 'John Doe',
        address: [double('address', line1: '123 Main St', city: 'Cityville', state: 'ST', zip: '12345')],
        party: 'Independent',
        photo_url: 'http://example.com/photo.jpg'
      }
      official_data_2 = {
        name: 'Jane Doe',
        address: [double('address', line1: '456 Main St', city: 'Cityville', state: 'ST', zip: '12345')],
        party: 'Independent',
        photo_url: 'http://example.com/photo.jpg',
        division_id: 'example_id'
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

    # before do
    #   allow(representative_class).to receive(:find_or_create_by).and_call_original
    #   representative_class.civic_api_to_representative_params(OpenStruct.new(official_data_1))
    # end

    # context 'when a representative is attempted to be created twice' do
    #   it 'does not create duplicate' do
    #     expect do
    #       representative_class.civic_api_to_representative_params(OpenStruct.new(official_data_1))
    #     end.not_to change(representative_class, :count)
    #   end
    # end

    # context 'when a new representative is added' do
    #   it 'creates a new representative' do
    #     representative_class.civic_api_to_representative_params(OpenStruct.new(official_data_2))
    #     expect(representative_class.count).to eq 2
    #   end
    # end

  end
end
