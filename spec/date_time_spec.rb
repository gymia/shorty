require 'spec_helper'

describe DateTime do
  describe '.shorty_current' do

    it 'returns ISO8601 format of now' do
      regex = /\d{2}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/
      expect(DateTime.shorty_current).to match(regex)
    end
  end
end
