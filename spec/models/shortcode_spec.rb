require 'rails_helper'

RSpec.describe Shortcode, type: :model do
  describe "validations" do
    let(:shortcode) { FactoryGirl.create(:shortcode) }
    let(:shortcode_without_shortcode) { FactoryGirl.create(:shortcode, shortcode: nil) }
    let(:shortcode_with_invalid_shortcode) { FactoryGirl.build(:shortcode, shortcode: 'e#a^p!e') }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:shortcode) }
    it { expect(shortcode.shortcode).to match(/^[0-9a-zA-Z_]{4,}$/) }
    it { expect(shortcode_without_shortcode.shortcode).to match(/^[0-9a-zA-Z_]{6}$/) }
    it "raises an error if shortcode does not match the regex" do
      shortcode_with_invalid_shortcode.valid?
      expect(shortcode_with_invalid_shortcode.errors.full_messages).to include("The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.")
    end
    it "increments hits count when visited method is called" do
      expect{
        shortcode.visited
      }.to change(shortcode,:hits).by(1)
    end
  end
end
