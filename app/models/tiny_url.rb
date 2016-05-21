class TinyUrl < ApplicationRecord
  include Slugifier

  SHORTCODE_REGEX        = /\A[0-9a-zA-Z_]{6}\Z/
  SHORTCODE_REGEX_STRING = SHORTCODE_REGEX.source.sub('\\A', '^').sub('\\Z', '$')

  validates :url, presence: true
  validates :shortcode,
    uniqueness: true,
    format: { with: SHORTCODE_REGEX },
    allow_blank: true

  slugify :shortcode, with: SHORTCODE_REGEX_STRING, unless: :shortcode
end
