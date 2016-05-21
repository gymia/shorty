require 'rails_helper'

describe TinyUrlStatsSerializer, type: :serializer do
  let(:resource) { FactoryGirl.create(:tiny_url) }
  let(:serializer) { described_class.new(resource) }
  let(:serialization) { serializer.as_json }

  it 'returns `redirectCount, lastSeenDate, startDate`' do
    expect(serialization.keys).to eq(%i(redirectCount lastSeenDate startDate))
  end

  context 'when redirection count is zero' do
    it 'should not have last_seen_date' do
      expect(serialization[:lastSeenDate]).to be_nil
    end
  end

  context 'when redirection count is not zero' do
    it 'should have last_seen_date' do
      resource.visit!
      expect(serialization[:lastSeenDate]).to be_present
    end
  end
end
