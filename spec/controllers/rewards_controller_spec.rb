require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question_reward) { create(:reward, question: question) }
  let(:reward) { create(:reward, question: question, user: user) }

  describe 'GET #index' do
    context 'Rewarded user' do
      before { login(user) }
      before { get :index }

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it 'user has reward' do
        expect(assigns(:rewards)).to eq([reward])
      end

      it "user hasn't reward" do
        expect(assigns(:rewards)).to_not eq([question_reward])
      end
    end
  end
end