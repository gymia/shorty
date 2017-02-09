Bundler.require :default

module Shorty
  module_function

  def redis
    @redis ||= Redis.new
  end
end

require "./lib/shorty/application.rb"
