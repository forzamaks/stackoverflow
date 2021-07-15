require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('DailyDigestServices') }

  before do
    allow(DailyDigestServices).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestServices#send_digest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
