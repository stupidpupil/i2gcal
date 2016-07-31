require 'icalendar'
require 'uuidtools'

module Icalendar

  UUID_ICAL_TO_GCAL_NAMESPACE = UUIDTools::UUID.parse('88cc3c53-51c9-4550-a469-7aefb4d066dc')

end

require 'synchrograph/icalendar_monkey_patches/better_timezones'
require 'synchrograph/icalendar_monkey_patches/dates_and_datetimes'
require 'synchrograph/icalendar_monkey_patches/event'
