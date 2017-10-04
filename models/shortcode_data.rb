class ShortcodeData < ActiveRecord::Base
  ERROR_MSG_REGEXP = 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'
  ERROR_MSG_URL = 'Url is not present'
  ERROR_MSG_ALREADY_TAKEN = 'The desired shortcode is already in use. Shortcodes are case-sensitive.'

  validate :shortcode, on: :create do |shortcode_data|
    if ShortcodeData.exists?(shortcode: shortcode_data.shortcode)
      shortcode_data.errors.add(:base, ERROR_MSG_ALREADY_TAKEN)
    end
  end
  #decided to keep url validation simple, thorough url validation probably requires a whole gem
  validate :url, on: :create do |shortcode_data|
    if shortcode_data.url.blank?
      shortcode_data.errors.add(:base, ERROR_MSG_URL)
    end
  end
  validate :shortcode, :on => :create do |shortcode_data|
    if !(shortcode_data.shortcode.match(/\A[0-9a-zA-Z_]{4,}\Z/))
      shortcode_data.errors.add(:base, ERROR_MSG_REGEXP)
    end
  end
  before_validation :set_random_token
  before_create :set_start_date

  def missing_url?
    self.errors[:base] == [ERROR_MSG_URL]
  end

  def code_already_taken?
    self.errors[:base] == [ERROR_MSG_ALREADY_TAKEN]
  end

  def code_invalid?
    self.errors[:base] == [ERROR_MSG_REGEXP]
  end

  private

  def self.generate_random_token
    range = [*'0'..'9',*'A'..'Z',*'a'..'z', '_']
    code = Array.new(6){ range.sample }.join
    #do we care about collisions? since we have 63^6 options for the code its very unlikely this will happen
    #and the requirements don't mention this so perhaps its out of scope for this exercise
    #however, if the service ever got big it could happen; and since if it happens it means one user will lose all traffic
    #we should disallow collisions completely by generating the token in a loop. Another option would have been to simply invalidate the model
    #and have the user make the request again but it seems unclean to me.
    code = Array.new(6){ range.sample }.join
    while (ShortcodeData.exists?(shortcode: code)) do
      code = Array.new(6){ range.sample }.join
    end
    return code
  end

  #generate new random token only if it wasnt already given
  def set_random_token
    self.shortcode = self.shortcode || ShortcodeData.generate_random_token
  end

  def set_start_date
    self.start_date =  DateTime.now
  end
end