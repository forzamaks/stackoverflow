require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer_with_files) { create(:answer, :with_file, question: question, user: user) }

  describe 'DELETE #destroy' do
    context 'Authorized user is author' do
      before { login(user) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: answer_with_files.files[0]  }, format: :js}.to change(answer_with_files.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer_with_files.files[0]  }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized other user' do
      before { login(second_user) }

      it 'tries do delete attachment' do
        expect { delete :destroy, params: { id: answer_with_files.files[0] }, format: :js}.to_not change(answer_with_files.files, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer_with_files.files[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete attachment' do
        expect { delete :destroy, params: { id: answer_with_files.files[0] }, format: :js}.to_not change(answer_with_files.files, :count)
      end

      it 'redirects to new session view' do
        delete :destroy, params: { id: answer_with_files }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end