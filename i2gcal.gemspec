require File.expand_path('../lib/i2gcal/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'i2gcal'
  s.version     = I2GCal::VERSION
  s.summary     = 'One-way sync an iCalendar file to Google Calendar'
  s.authors     = ['Adam Watkins']
  s.files       = Dir['lib/**/*.rb', 'lib/i2gcal.rb', 'lib/synchrograph.rb']
  s.license     = 'AGPL-3.0'
  s.homepage    = 'https://github.com/stupidpupil/i2gcal'

  s.add_runtime_dependency 'google-api-client', '0.8'
  s.add_runtime_dependency 'activesupport', '~> 5.0'
  s.add_runtime_dependency 'icalendar', '~> 2.4'
  s.add_runtime_dependency 'uuidtools', '~> 2.1'

  s.add_development_dependency 'bacon', '~> 1.2'
end

