class Shortcode < ActiveRecord::Base

  include ::ShortcodeGenerator

  before_validation :set_shortcode

  validates :url, presence: true
  validates :shortcode, uniqueness: true
  validate  :shortcode_matches_the_regex

  def shortcode_matches_the_regex
    errors.add(:base, "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.") unless shortcode =~ /\A[0-9a-zA-Z_]{4,}\z/
  end

  def set_shortcode
    self.shortcode = self.generate_random_shortcode unless self.shortcode
  end

  def visited
    self.increment!(:hits)
  end

end
