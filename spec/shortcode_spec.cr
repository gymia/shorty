require "./spec_helper"

describe Shorty::Shortcode do
  it "should generate a valid shortcode" do
    10.times do
      shortcode = Shorty::Shortcode.generate()
      shortcode.match(Shorty::Shortcode::REGEX).should be_truthy
    end
  end
end
