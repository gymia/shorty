require 'spec_helper'

describe Shorty::Shortcode::Validator do
  describe '#qualified?' do
    context 'given a nil shortcode' do
      subject { described_class.new(nil).qualified? }
      it { is_expected.to be_falsy }
    end

    context 'given a valid shortcode' do
      subject { described_class.new('abc123').qualified? }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with less than 4 chars' do
      subject { described_class.new('ab1').qualified? }
      it { is_expected.to be_falsy }
    end

    context 'given a shortcode with only numbers' do
      subject { described_class.new('112233').qualified? }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with only letters' do
      subject { described_class.new('aabbcc').qualified? }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with only underscores' do
      subject { described_class.new('______').qualified? }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with no letter, number or underscore' do
      subject { described_class.new('123ab!').qualified? }
      it { is_expected.to be_falsy }
    end
  end

  describe '#perform' do
    context 'given a shortcode in use' do
      before do
        Shorty::Models::Shorty.new(url: 'google.com', shortcode: '123123').create
      end
      expected_hash = {
        message: "The the desired shortcode is already in use. Shortcodes are case-sensitive.",
        code: 409
      }
      subject { described_class.new('123123').perform }

      it { is_expected.to eq(expected_hash)}
    end

    context 'given a shortcode not qualified(does not match regex)' do
      expected_hash = {
        message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$",
        code: 422
      }
      subject { described_class.new('123').perform }

      it { is_expected.to eq(expected_hash)}
    end

    context 'given a valid shortcode' do
      subject { described_class.new('abc123').perform }
      it { is_expected.to be_nil }
    end

    context 'given a nil shortcode' do
      subject { described_class.new(nil).perform }
      it { is_expected.to be_nil }
    end
  end
end
