class Url < ApplicationRecord
  extend FriendlyId
  friendly_id :short_code, use: :slugged

  before_validation :create_short_code, unless: :short_code?

  validates :short_code,
            uniqueness: { message: 'The the desired shortcode is already in use.' },
            format: { with: /\A[0-9a-zA-Z_]{4,}\z/, message: 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.' }

  private

  def create_short_code
    self.short_code = /\A[0-9a-zA-Z_]{6}\z/.random_example
  end
end
