class ShortcodeData < ActiveRecord::Base
  validates_uniqueness_of :shortcode

  def self.generate_random_token
    range = [*'0'..'9',*'A'..'Z',*'a'..'z']
    Array.new(100){ range.sample }.join
  end
end