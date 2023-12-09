# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe User, type: :model do
#   describe 'methods' do
#     let(:user) { create(:user, provider: 'google_oauth2', uid: '12345') }

#     it 'returns the full name' do
#       expect(user.name).to eq("#{user.first_name} #{user.last_name}")
#     end

#     it 'returns the authentication provider name' do
#       expect(user.auth_provider).to eq('Google')
#     end

#     describe '.find_google_user' do
#       it 'finds a user by UID and provider' do
#         found_user = described_class.find_google_user(user.uid)
#         expect(found_user).to eq(user)
#       end
#     end

#     describe '.find_github_user' do
#       it 'finds a user by UID and provider' do
#         found_user = described_class.find_github_user(user.uid)
#         expect(found_user).to be_nil
#       end
#     end
#   end
# end