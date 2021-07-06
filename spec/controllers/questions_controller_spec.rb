require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user)}
    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index 
    end
  end

  describe 'GET #show' do
    
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show 
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new 
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question.where(user: user), :count).by(1)
      end
      it 'redirect to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-render new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question, user: user) }
    let!(:second_user) { create(:user) }
    let!(:second_question) { create(:question, user: second_user) }

    context 'Authorized author' do

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question.where(user: user), :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Authorized other user' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: second_question } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: second_question }
        expect(response).to redirect_to questions_path
      end
    end
    
  end

  describe 'PATH #update' do
    before { login(user) }
    let!(:second_user) { create(:user) }
    let!(:second_answer) {create :question, user: second_user }
    

    context 'with valid attributes' do
      it 'change question attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to eq 'new body'
      end
      it 'render update views' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :body)
      end

      it 'render update views' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Authorized user' do
      before { login(second_user) }
      it 'Edit the question' do
        patch :update, params: { id: question, question: { body: 'new second body' } }, format: :js 
        question.reload
        expect(question.body).to_not eq 'new second body'
      end
    end


    context 'Authenticated author' do
      it 'update the question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        question.reload
        expect(question.body).to eq question.body
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

  end
end