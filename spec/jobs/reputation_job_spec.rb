require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:user) {create(:user)}
  let(:question) { create(:question, user: user) }

  it 'calls ReputationJob#calculate' do
    expect(ReputationJob).to receive(:calculate).with(question)
    ReputationJob.perform_later(question)
  end 
end
