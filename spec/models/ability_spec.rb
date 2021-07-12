require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) {create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) {create :user}
    let(:other) {create :user}

    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :destroy, Answer }

      it { should be_able_to :update, create(:answer, user: user, question: question) }
      it { should_not be_able_to :update, create(:answer, user: other, question: other_question) }

      it { should be_able_to :mark_as_best, create(:answer, user: user, question: question) }
      it { should_not be_able_to :mark_as_best, create(:answer, user: other, question: other_question) }

      it { should_not be_able_to [:vote_up, :vote_down, :unvote], create(:answer, user: user, question: question) }
      it { should be_able_to [:vote_up, :vote_down, :unvote], create(:answer, user: other, question: other_question) }

      it { should be_able_to [:comment], Answer }

    end
    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, Question }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should_not be_able_to [:vote_up, :vote_down, :unvote], question }
      it { should be_able_to [:vote_up, :vote_down, :unvote], other_question }

      it { should be_able_to [:comment], Question }
    end

    context 'Link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end
  end
end