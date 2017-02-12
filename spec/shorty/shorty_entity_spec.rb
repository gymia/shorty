require 'spec_helper'

describe Shorty::ShortyEntity do
  describe '#create' do
    context 'given url only' do
      let(:shorty) { described_class.new({url: 'facebook.com'}) }

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
      let(:shorty) do
        described_class.new({url: 'facebook.com', shortcode: '11aab2'})
      end

      it 'returns itself' do
        expect(shorty.create).to be_an_instance_of(described_class)
      end

      it 'returns with given shortcode' do
        shorty.create
        expect(shorty.shortcode).to eq('11aab2')
      end
    end

    context 'given an invalid shortcode' do
      let(:shorty) { described_class.new({url: 'facebook.com', shortcode: 'aaa'}) }

      it 'returns false' do
        expect(shorty.create).to be_falsy
      end
    end

    context 'given an already existing shortcode' do
      before do
        described_class.new({url: 'facebook.com', shortcode: 'abc'}).create
      end
      let(:shorty) { described_class.new({url: 'facebook.com', shortcode: 'abc'}) }

      it 'returns false' do
        expect(shorty.create).to be_falsy
      end
    end
  end

  describe '.find' do
    context 'given an existing shortcode' do
      before do
        described_class.new({url: 'facebook.com', shortcode: '1a2b3c'}).create
      end
      subject { described_class.find('1a2b3c') }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'given an unexistent shortcode' do
      subject { described_class.find('aaa111') }

      it { is_expected.to be_nil }
    end
  end

  describe '#shortened_url' do
    context 'given a shortcode' do
      subject do
        described_class.new({url: 'google.com', shortcode: '111222'}).shortened_url
      end
      it { is_expected.to eq('http://111222') }
    end

    context 'without shortcode' do
      subject { described_class.new({url: 'google.com'}).shortened_url }
      it { is_expected.to be_nil }
    end
  end

  describe '#increment_redirect' do
    let!(:shorty) { described_class.new({url: 'google.com'}).create }
    let(:date) { DateTime.new(2017, 1, 20) }
    before { allow(DateTime).to receive(:now).and_return(date) }

    it 'updates last seen date with current datetime' do
      shorty.increment_redirect
      expect(shorty.reload.last_seen_date).to eq("2017-01-20T00:00:00.000Z")
    end

    it 'increments redirect count by 1' do
      expect{shorty.increment_redirect}.to change{shorty.reload.redirect_count}.by(1)
    end
  end
end
