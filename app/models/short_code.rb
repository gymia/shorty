require 'mongoid'

class ShortCode
  include Mongoid::Document

  field :url, type: String
  field :shortcode, type: String
  field :start_date, type: DateTime
  field :last_seen_date, type: DateTime
  field :redirect_count, type: Integer
end
