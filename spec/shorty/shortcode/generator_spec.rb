require 'spec_helper'

describe Shorty::Shortcode::Generator do
  describe '#perform' do
    context 'given a very short url' do
      subject { described_class.perform('1') }

      it { is_expected.to match(/^[0-9a-zA-Z_]{6}$/) }
      it { is_expected.to eq('b94857') }
    end

    context 'given another very short url' do
      subject { described_class.perform('a') }

      it { is_expected.to match(/^[0-9a-zA-Z_]{6}$/) }
      it { is_expected.to eq('166277') }
    end

    context 'given similar prefix urls' do
      let(:google) { described_class.perform('google.com.br') }
      let(:moogle) { described_class.perform('moogle.com.br') }

      it 'generates different shortcodes' do
        expect(google).to_not eq(moogle)
      end
    end

    context 'given a bigger url' do
      subject do
        described_class.perform(
          'http://steamcommunity.com/sharedfiles/filedetails/?id=857773350'
        )
      end

      it { is_expected.to match(/^[0-9a-zA-Z_]{6}$/) }
      it { is_expected.to eq('445159') }
    end
  end

  describe '#shortener' do
    context 'given a shortcode' do
      subject { described_class.shortener('111222') }
      it { is_expected.to eq('http://111222') }
    end

    context 'without shortcode' do
      subject { described_class.shortener }
      it { is_expected.to be_nil }
    end
  end
end
