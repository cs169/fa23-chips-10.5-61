require 'rails_helper'
require 'spec_helper'

RSpec.describe Event, type: :model do
  describe '#county_names_by_id' do
    let(:event) { described_class.new } 

    context 'when county and state exist in the database' do
      it 'returns county name to id hash' do
        allow(event).to receive(:county_names_by_id).and_return({ 'County Name' => 'Sacramento' })
        expect(event.county_names_by_id).to eq({ 'County Name' => 'Sacramento' })
      end
    end
    context 'when county or state does not exist in the database' do
      it 'returns empty hash' do
        allow(event).to receive_message_chain(:county, :state, :counties).and_return(nil)
        expect(event.county_names_by_id).to eq({})
      end
    end
  end
end