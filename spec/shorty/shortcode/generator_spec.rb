require 'spec_helper'

describe Shorty::Shortcode::Generator do
  describe '.run' do
    it 'generates a valid random shortcode' do
      expect(described_class.run).to match(/^[0-9a-zA-Z_]{6}$/)
    end
  end
end
