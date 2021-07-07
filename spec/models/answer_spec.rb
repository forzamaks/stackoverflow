require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :body }

  describe 'best answer' do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    let!(:second_answer) { create(:answer, question: question, user: second_user) }

    context 'mark best' do
      it 'marked the best' do
        answer.mark_as_best
        expect(answer).to be_best
      end

      it 'Unmarked the best' do
        second_answer.mark_as_best
        expect(second_answer).to be_best
        answer.mark_as_best
        answer.reload
        second_answer.reload
        expect(answer).to be_best
        expect(second_answer).to_not be_best
      end

      it 'only one answer may be the best' do
        answer.mark_as_best
        second_answer.mark_as_best
        expect(question.answers.where(best: true).count).to eq 1
      end
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
