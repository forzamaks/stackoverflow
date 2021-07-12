require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'User is author of question' do
    expect(user).to be_author_of(question)
  end
  it 'User is author of answer' do
    expect(user).to be_author_of(answer)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthServicesh') }

    it 'class FindForOauthServices' do
      expect(FindForOauthServices).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)

      User.find_for_oauth(auth)
    end
  end
end
