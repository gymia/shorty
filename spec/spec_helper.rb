require 'rspec'
require './lib/shorty'
require 'fakeredis'
require 'pry'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.before(:each) do
    Shorty.redis.flushall
  end
end
