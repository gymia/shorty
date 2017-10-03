# Rakefile

require 'rake'
require 'bundler'
Bundler.setup
require 'grape-raketasks'
require 'grape-raketasks/tasks'
require "bundler/setup"
load "tasks/otr-activerecord.rake"

desc 'load the Sinatra environment.'
task :environment do
  require File.expand_path('impraise_api', File.dirname(__FILE__))
end