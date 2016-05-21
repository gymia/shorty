require 'rails_helper'

describe TinyUrl, type: :model do
  let(:subject) { FactoryGirl.build(:tiny_url) }

  it 'defines regex for shortcode' do
    expect(described_class::SHORTCODE_REGEX).to eq(/\A[0-9a-zA-Z_]{6}\Z/)
  end

  it 'defines regex(SHORTCODE_REGEX) equivalent string(SHORTCODE_REGEX_STRING)' do
    expect(described_class::SHORTCODE_REGEX_STRING).to eq('^[0-9a-zA-Z_]{6}$')
  end

  describe 'Validations' do
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:shortcode) }
    it { should allow_value(Faker::Base.regexify(Regexp.new(described_class::SHORTCODE_REGEX_STRING))).for(:shortcode) }
    it { should_not allow_values('wrong value', 'invalid').for(:shortcode) }
  end

  context 'when pre-defined shortcode is absent' do
    it 'generates a new shortcode' do
      expect(subject.shortcode).to be_nil
      subject.save!
      expect(subject.shortcode).to be_present
    end
  end

  describe '#visit!' do
    before { subject.save! }

    it 'updates attributes(increment redirect_count, update last_seen_at) when a user visits a tiny url' do
      expect { subject.visit! }.to change { subject.last_seen_at }
      expect { subject.visit! }.to change { subject.redirect_count }.by(1)
    end
  end
end
