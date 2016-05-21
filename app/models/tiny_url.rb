class TinyUrl < ApplicationRecord
  include Slugifier

  SHORTCODE_REGEX_STRING = '[0-9a-zA-Z_]{6}'
  SHORTCODE_REGEX        = /\A#{SHORTCODE_REGEX_STRING}\Z/

  validates :url, presence: true
  validates :shortcode,
    uniqueness: true,
    format: { with: SHORTCODE_REGEX },
    allow_blank: true

  slugify :shortcode, with: SHORTCODE_REGEX_STRING, unless: :shortcode
end
