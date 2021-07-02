require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers.where(user: user), :count).by(1)
      end
      it 'redirect to show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-render new' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end
end