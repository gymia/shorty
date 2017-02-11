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
      let(:shorty) { described_class.new("facebook.com", "11aab2") }

      it 'returns itself' do
        expect(shorty.create).to be_an_instance_of(described_class)
      end

      it 'returns with given shortcode' do
        shorty.create
        expect(shorty.shortcode).to eq("11aab2")
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

  describe '.find' do
    context 'given an existing shortcode' do
      before { described_class.new("facebook.com", "1a2b3c").create }
      subject { described_class.find("1a2b3c") }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'given an unexistent shortcode' do
      subject { described_class.find("aaa111") }

      it { is_expected.to be_nil }
    end
  end

  describe '#shortened_url' do
    context 'given a shortcode' do
      subject { described_class.new("google.com", "111222").shortened_url }
      it { is_expected.to eq("http://111222") }
    end

    context 'without shortcode' do
      subject { described_class.new("google.com").shortened_url }
      it { is_expected.to be_nil }
    end
  end
end
