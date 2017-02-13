require 'spec_helper'

describe Shorty do
  describe '#redis' do
    it 'returns a valid redis connection' do
      expect(described_class.redis).to be_an_instance_of(Redis)
    end
  end
end
