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
    it "raises an error if shortcode does not meet the regex" do
      shortcode_with_invalid_shortcode.valid?
      shortcode_with_invalid_shortcode.errors.full_messages.should include("The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.")
    end
  end
end
