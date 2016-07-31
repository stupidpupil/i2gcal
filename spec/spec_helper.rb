if ENV['TRAVIS']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'
  SimpleCov.start
end

require 'synchrograph'

FIXTURES_DIR = File.expand_path('../fixtures/', __FILE__)