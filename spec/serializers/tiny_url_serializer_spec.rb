require 'rails_helper'

RSpec.describe TinyUrlSerializer, type: :serializer do
  let(:resource) { FactoryGirl.build(:tiny_url, shortcode: 'TtEgds') }
  let(:serializer) { described_class.new(resource) }
  let(:serialization) { serializer.as_json }

  it "returns shortcode" do
    expect(serialization).to eq({ shortcode: 'TtEgds' })
  end
end
