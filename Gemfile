source 'https://rubygems.org'

ruby '2.2.4'

gem 'rails',                       '5.0.0.rc1'
gem 'mysql2',                      '0.4.4'
gem 'puma',                        '~> 3.4.0'
gem 'faker',                       '~> 1.6.1', require: false
gem 'active_model_serializers',    '~> 0.9.4'

group :development, :test do
  gem 'byebug',                    '~> 9.0.4', platform: :mri
end

group :test do
  gem 'database_cleaner',          '~> 1.5.1'
  gem 'factory_girl_rails',        '~> 4.5.0'
  gem 'rspec-rails',               '~> 3.1.0'
  gem 'shoulda-callback-matchers', '~> 1.1.3',  require: false
  gem 'shoulda-matchers',          '~> 3.1.0',  require: false
  gem 'simplecov',                 '~> 0.11.1', require: false
end

group :development do
  gem 'listen',                    '~> 3.0.5'
  gem 'spring',                    '~> 1.7.1'
  gem 'spring-watcher-listen',     '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data',                 '~> 1.2.2', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
