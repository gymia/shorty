require 'spec_helper'

describe Shorty::Shortcode::Validator do
  describe '.qualified?' do
    context 'given a nil shortcode' do
      subject { described_class.qualified?(nil) }
      it { is_expected.to be_truthy }
    end

    context 'given a valid shortcode' do
      subject { described_class.qualified?('abc123') }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with less than 6 chars' do
      subject { described_class.qualified?('ab12') }
      it { is_expected.to be_falsy }
    end

    context 'given a shortcode with only numbers' do
      subject { described_class.qualified?('112233') }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with only letters' do
      subject { described_class.qualified?('aabbcc') }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with only underscores' do
      subject { described_class.qualified?('______') }
      it { is_expected.to be_truthy }
    end

    context 'given a shortcode with no letter, number or underscore' do
      subject { described_class.qualified?('123ab!') }
      it { is_expected.to be_falsy }
    end
  end
end
