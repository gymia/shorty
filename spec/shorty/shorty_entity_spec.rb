require 'spec_helper'

describe Shorty::ShortyEntity do
  describe '#create' do
    context 'given url only' do
      let(:shorty) { described_class.new("facebook.com") }

      it 'retuns itself' do
        expect(shorty.create).to be_an_instance_of(described_class)
      end

      it 'generates a shortcode' do
        shorty.create
        expect(shorty.shortcode).to_not be_nil
      end

      it 'does not return false' do
        expect(shorty.create).to_not be_falsy
      end
    end

    context 'given a valid shortcode' do
      let(:shorty) { described_class.new("facebook.com", "abc") }

      it 'returns itself' do
        expect(shorty.create).to be_an_instance_of(described_class)
      end
    end

    context 'given an invalid shortcode' do
      let(:shorty) { described_class.new("facebook.com", "aaa") }

      it 'returns false' do
        expect(shorty.create).to be_falsy
      end
    end

    context 'given an already existing shortcode' do
      before { described_class.new("facebook.com", "abc").create }
      let(:shorty) { described_class.new("facebook.com", "abc") }

      it 'returns false' do
        expect(shorty.create).to be_falsy
      end
    end
  end
end
