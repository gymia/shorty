require 'rack/test'
require_relative '../app'

ENV['RACK_ENV'] = 'test'

def app
  App
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
