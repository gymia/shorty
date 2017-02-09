require './lib/shorty.rb'

use Rack::Reloader unless ENV['RACK_ENV'] == 'production'
run Shorty::Application.router
