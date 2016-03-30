require "./spec_helper"

describe Shorty::CodeGenerator do
  it "should generate a valid shortcode" do
    code_generator = Shorty::CodeGenerator.new

    10.times do
      shortcode = code_generator.generate()
      shortcode.match(Shorty::CodeGenerator::REGEX).should be_truthy
    end
  end
end
