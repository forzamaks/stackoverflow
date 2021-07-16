require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #index' do
    subject { post :search, params: {body: "", type: "All" } }

    it 'render search template' do
      subject
      expect(response).to render_template :index
    end
  end
end