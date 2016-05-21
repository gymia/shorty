FactoryGirl.define do
  factory :tiny_url do
    url { Faker::Internet.url }
  end
end
