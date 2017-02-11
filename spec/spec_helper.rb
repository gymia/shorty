require 'rspec'
require 'fakeredis'
require 'pry'
require 'rack/test'
require './lib/shorty'

include Rack::Test::Methods
ENV['RACK_ENV'] = 'test'


RSpec.configure do |config|
  config.before(:each) do
    Shorty.redis.flushall
  end
end
