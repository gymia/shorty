require 'mongoid'
require "rubygems"
require "bundler"

module Sinatra
  module Config

    def self.registered(app)
      # App settings
      app.set :root, File.expand_path('..')
      app.set :app_file, File.expand_path('../app.rb')

      # Database settings
      Mongoid.load!('config/mongoid.yml')
      Mongoid.raise_not_found_error = false
    end
  end
end
