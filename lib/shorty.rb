Bundler.require :default
require 'yaml'

module Shorty
  module_function

  def redis
    config = YAML::load_file(File.join('./config', 'redis.yml'))
    @redis ||= Redis.new(config)
  end
end

require "./lib/shorty/application.rb"
