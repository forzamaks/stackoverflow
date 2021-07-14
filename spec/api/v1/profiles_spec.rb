require 'rails_helper'

describe 'profile API', type: :request do
  let(:headers) { { 
    "ACCEPT" => "application/json"
   } }
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) {'/api/v1/profiles/me'}
    it_behaves_like 'API Authorizable' do
      let(:method) {:get }
    end

    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      it 'return status 200' do
        expect(response).to be_successful 
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encripted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end
  describe 'GET /api/v1/profiles' do
    let(:api_path) {'/api/v1/profiles'}
    it_behaves_like 'API Authorizable' do
      let(:method) {:get }
      
    end


    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) { create(:access_token) }
      let!(:users) {create_list(:user, 2)}
      let(:user) { users.first }
      let(:user_response) { json['users'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Success requestable'

      it_behaves_like 'Public fields returnable' do
        let(:resource) { user }
        let(:resource_response) { user_response }
        let(:items) { %w[id email admin created_at updated_at] }
      end

      it_behaves_like 'Resource count returnable' do
        let(:resource_response) { json['users'] }
        let(:resource) { users }
      end

      it 'does not returns private fields' do
        %w[password encripted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end

      
    end
  end
end