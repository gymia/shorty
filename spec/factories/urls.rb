FactoryGirl.define do
  factory :url do
    url { Faker::Internet.url }
    start_date { Time.current }

    factory :url_with_short_code do
      short_code { Faker::Lorem.characters(6) }
    end
  end
end
