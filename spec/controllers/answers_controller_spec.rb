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
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers.where(user: user), :count).by(1)
      end
      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) {create :answer, question: question, user: user }
    let!(:second_user) { create(:user) }
    let!(:second_answer) {create :answer, question: question, user: second_user }

    context 'Authorized author' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render view destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized other user' do
      it 'delete anothers answer' do
        expect { delete :destroy, params: { id: second_answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render view destroy' do
        delete :destroy, params: { id: second_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end  
  end

  describe 'PATH #update' do
    before { login(user) }
    let!(:answer) {create :answer, question: question, user: user }
    let!(:second_user) { create(:user) }
    let!(:second_answer) {create :answer, question: question, user: second_user }
    

    context 'with valid attributes' do
      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'render update views' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update views' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Authorized user' do
      before { login(second_user) }
      it 'Edit the answer' do
        patch :update, params: { id: answer, answer: { body: 'new second body' } }, format: :js 
        answer.reload
        expect(answer.body).to_not eq 'new second body'
      end
    end


    context 'Authenticated author' do
      it 'update the answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

  end

  describe 'POST #mark_best_answer' do
    let!(:second_user) { create(:user) }
    context 'The owner of the question is trying to mark the answer as the best' do
      before { login(user) }
      before { post :mark_as_best, params: { id: answer }, format: :js }

      it 'mark best answer' do
        expect { answer.reload }.to change { answer.best }.from(false).to(true)
      end

      it 'renders best template' do
        expect(response).to render_template :mark_as_best
      end
    end

    context 'Not the owner of the question is trying to mark the answer as the best' do
      before { login(second_user) }
      before { post :mark_as_best, params: { id: answer }, format: :js }

      it 'Do not mark the best answer' do
        expect { answer.reload }.to_not change(answer, :best)
      end

      it 'renders best template' do
        expect(response).to render_template :mark_as_best
      end
    end
  end
end