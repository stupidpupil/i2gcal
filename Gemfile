source 'https://rubygems.org'

gem 'google-api-client', '0.8'
gem 'activesupport', '~> 5.0'
gem 'icalendar', '~> 2.4'
gem 'uuidtools', '~> 2.1'

group :development do
  gem 'bacon', '~> 1.2'
end

group :test do
  if ENV['TRAVIS']
    gem 'codeclimate-test-reporter', require: false
  else
    gem 'simplecov', require: false
  end
end
