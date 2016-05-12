require 'rack/test'
require_relative '../app'
require 'factory_girl'

ENV['RACK_ENV'] = 'test'

def app
  App
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.before(:all) do
    Mongoid.load!("config/mongoid.yml", :test)
  end

  config.after(:all) do
    db = Mongoid.client(:default)
    db.collections.each do |collection|
      collection.drop
    end
  end
end
