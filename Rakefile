# Rakefile
require 'rake'
require 'bundler'
require 'grape'
Bundler.setup

load "tasks/otr-activerecord.rake"

# task :environment do
#   require File.expand_path('impraise_api', File.dirname(__FILE__))
# end

namespace :db do
  # Some db tasks require your app code to be loaded; they'll expect to find it here
  task :environment do
    require_relative 'impraise_api'
  end
end