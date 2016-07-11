require 'rails_helper'

describe Url, type: :model do
  context 'callbacks' do
    it { is_expected.to callback(:create_short_code).before(:validation).unless(:short_code?) }

    describe '#create_short_code' do
      it 'creates a random short_code when a url register is saved without one' do
        url = build :url, short_code: nil

        expect { url.save }.to change { url.short_code }
        expect(url.reload.short_code).to match(/\A[0-9a-zA-Z_]{6}\z/)
      end

      it 'does not change an existing short_code on the register creation' do
        url = build :url, short_code: 'asdf'

        expect { url.save }.to_not change { url.short_code }
        expect(url.reload.short_code).to eq('asdf')
      end
    end
  end

  context 'validations' do
    it { is_expected.to validate_uniqueness_of(:short_code).with_message('The the desired shortcode is already in use.') }
    it { is_expected.to allow_value('asdf', 'aSdF', '1234', 'aS2f').for(:short_code) }
    it { is_expected.to_not allow_value('a', 'asd', '1', '123').for(:short_code).with_message('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.') }
  end
end
