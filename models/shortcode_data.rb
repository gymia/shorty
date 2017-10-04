class ShortcodeData < ActiveRecord::Base
  validates_uniqueness_of :shortcode
  #decided to keep url validation simple, thorough url validation probably requires a whole gem
  validates_presence_of :url
  validates_format_of :shortcode, :with => /\A[0-9a-zA-Z_]{4,}\Z/, :on => :create
  after_initialize :set_random_token
  after_initialize :set_start_date

  def self.generate_random_token
    range = [*'0'..'9',*'A'..'Z',*'a'..'z', '_']
    Array.new(6){ range.sample }.join
  end

  #generate new random token only if it wasnt already given
  def set_random_token
    if self.new_record?
      self.shortcode = self.shortcode || ShortcodeData.generate_random_token
    end
  end

  def set_start_date
    self.start_date =  DateTime.now
  end
end