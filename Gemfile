# frozen_string_literal: true

source 'https://rubygems.org'

gem 'activerecord-import'
gem 'bootsnap', require: false
gem 'dotenv-rails'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.1'
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-scheduler'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw], require: 'debug/prelude'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
end
