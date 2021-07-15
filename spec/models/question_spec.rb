require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'commentable'
  it_behaves_like 'linkable'
  it_behaves_like 'voteble'
  
  it { should belong_to(:user) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:user) {create(:user)}
    let(:question) { build(:question, user: user) }

    it 'calls ReputationJob perform_later' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end

  end
end
