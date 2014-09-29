require 'rails_helper'


describe ShortCode do
  context 'validations' do
    it { should validate_uniqueness_of :shortcode }
    it { allow_value(/^[0-9a-zA-Z_]{4,}$/).for(:shortcode) }
  end

  context "shortcode generator" do
    let(:short_code) { build(:short_code) }

    it 'generates short code' do
      expect(short_code.generate.length).to be >= 4
    end

    it 'short code generated when missing' do
      short_code.save
      expect(short_code.shortcode).not_to be_empty
    end
  end

end

