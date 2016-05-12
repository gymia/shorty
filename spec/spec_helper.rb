require 'rack/test'
require_relative '../app'

ENV['RACK_ENV'] = 'test'

def app
  App
end

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:all) do
    Mongoid.load!("config/mongoid.yml", :test)
  end

  config.after(:all) do
    db = Mongoid.client(:test)
    db.collections.each do |collection|
      collection.drop
    end
  end
end
