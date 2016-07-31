require 'icalendar'

require 'synchrograph/icalendar_monkey_patches'
require 'synchrograph/api_client_builder'
require 'synchrograph/gcalendar'

# Glues together the API Client, the GCalendar and the ICalendar
# to create the right requests, in the right order and submit them 
class Synchrograph
  
  def initialize(api_client)
    @client = api_client
  end


  def synchronise(gcalendar, icalendar)

    ical_events = icalendar.first.events.find_all {|ie| ie.recurrence_id.nil?}
    gcal_events = gcalendar.events

    response_body = ""

    #Insert or update
    ical_events.each do |ie|
      ge = gcal_events.find {|ge| ge['id'] == ie.google_calendar_id}

      gcalendar.add_request_for_gcal_event_and_ical_event ge, ie
      
    end

    (gcal_events.find_all {|ge| ge['recurring_event_id'].nil? and not ical_events.map {|ie| ie.google_calendar_id}.include?(ge['id'])}).each do |ge|
      gcalendar.add_request_for_gcal_event_and_ical_event ge, nil
    end

    response_body << gcalendar.execute_requests.body

    #Now deal with recurrence exceptions
    ical_events = icalendar.first.events.find_all {|ie| not ie.recurrence_id.nil?}

    ical_events.group_by {|ie| ie.google_calendar_id}.each_pair do |ge_id, re_e|
      gcal_instances = gcalendar.instances_for_event_id ge_id

      re_e.each do |ie|
        instance = gcal_instances.find {|i| i.start.date_time == ie.recurrence_id}
        next if instance.nil?

        ie.update_from_parent_component!

        ie.google_calendar_id = instance.id
        gcalendar.add_request_for_gcal_event_and_ical_event(instance, ie)
      end
    end

    er = gcalendar.execute_requests
    response_body << er.body if er

    return response_body
  end

end