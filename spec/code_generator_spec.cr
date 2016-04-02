require "./spec_helper"

describe Shorty::CodeGenerator do
  it "should generate a valid shortcode" do
    repository = Shorty::MemoryRepository.new
    code_generator = Shorty::CodeGenerator.new(repository)

    10.times do
      shortcode = code_generator.generate()
      shortcode.match(Shorty::CodeGenerator::REGEX).should be_truthy
    end
  end

  it "should validate user preferred shortcode" do
    repository = Shorty::MemoryRepository.new
    code_generator = Shorty::CodeGenerator.new(repository)

    code_generator.valid?("0aA_").should be_true
    code_generator.valid?("0aA-").should be_false
    code_generator.valid?("go").should be_false
  end
end
