require 'factory_girl'

FactoryGirl.define do
  factory :short_code do
    url "www.google.com"
    shortcode "shortcode"
    redirect_count 3
    start_date Time.now.utc.iso8601
    last_seen_date Time.now.utc.iso8601
  end
end
