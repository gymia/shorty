require_relative 'spec_helper'
describe Impraise::API do
  include Rack::Test::Methods

  def app
    Impraise::API
  end

  context 'Model' do
    context 'invalid' do
      it 'is not valid if shortcode too short' do
        code = ShortcodeData.new(url: 'htawszzz', shortcode: 'aaa')
        code.validate
        expect(code.errors.full_messages).to include('Shortcode is invalid')
      end
      it 'is not valid if shortcode has non alphanumeric' do
        code = ShortcodeData.new(url: 'aasdasdasd@@', shortcode: 'aaa')
        code.validate
        expect(code.errors.full_messages).to include('Shortcode is invalid')
      end
      it 'is not valid if url is missing' do
        code = ShortcodeData.new(url: '', shortcode: 'aaaa')
        code.validate
        expect(code.errors.full_messages).to include("Url can't be blank")
      end
    end

    context 'valid' do
      it 'should be valid if provided url and alphanumeric shortcode' do
        code = ShortcodeData.new(url: 'http://www.google.com', shortcode: 'aaaaQQ12345ff')
        expect(code.valid?).to be_truthy
      end

      it 'should generate valid shortcode of exactly 6 chars if non was given' do
        code = ShortcodeData.new(url: 'http://www.google.com')
        expect(code.shortcode.length).to eq(6)
      end

      it 'shouldnt override shortcode if shortcode was given' do
        code = ShortcodeData.new(url: 'http://www.google.com', shortcode: 'aaaaQQ12345ff')
        expect(code.shortcode).to eq('aaaaQQ12345ff')
      end
    end
  end
end