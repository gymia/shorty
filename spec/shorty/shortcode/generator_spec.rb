require 'spec_helper'

describe Shorty::Shortcode::Generator do
  describe '.run' do
    context 'given a very short url' do
      subject { described_class.run("1") }

      it { is_expected.to match(/^[0-9a-zA-Z_]{6}$/) }
      it { is_expected.to eq("EzLvoD") }
    end

    context 'given another very short url' do
      subject { described_class.run("a") }

      it { is_expected.to match(/^[0-9a-zA-Z_]{6}$/) }
      it { is_expected.to eq("E2LvoD") }
    end

    context 'given a bigger url' do
      subject do
        described_class.run(
          "http://steamcommunity.com/sharedfiles/filedetails/?id=857773350"
        )
      end

      it { is_expected.to match(/^[0-9a-zA-Z_]{6}$/) }
      it { is_expected.to eq("Dc0RHa") }
    end
  end
end
