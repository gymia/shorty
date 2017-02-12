require 'spec_helper'

describe Hash do
  describe '#symbolize_keys' do
    let(:string_keys_hash) { {'a' => 1, 'b' => 2} }

    it 'turns string keys into symbol' do
      expect(string_keys_hash.symbolize_keys).to eq({a: 1, b: 2})
    end
  end
end
