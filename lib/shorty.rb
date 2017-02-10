Bundler.require :default
require 'yaml'
require 'pry' unless ENV['RACK_ENV'] = 'production'


module Shorty
  module_function

  def redis
    config = YAML::load_file(File.join('./config', 'redis.yml'))
    @redis ||= Redis.new(config['redis'])
  end
end

require "./lib/shorty/application.rb"
require "./lib/shorty/short_code/validator.rb"
require "./lib/shorty/short_code/generator.rb"
require "./lib/shorty/shorty_entity.rb"
