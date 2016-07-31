require 'synchrograph/filters/base'
require 'synchrograph/filters/categories_to_colours'

# Handles generating fetching the existing list of events in GCal
# and generating requests to correct this list
class GCalendar

  attr_reader :client, :gcal_id

  def initialize(api_client, gcal_identifier)
    @client = api_client
    @gcal_id = gcal_identifier
    @pending_requests = []

    #categories = icalendar.first.events.map {|e| e.categories}.flatten.uniq { |u| u.to_s}
    #cat_to_col_mapping = {}
    #categories.each_with_index do |c, i|
    #  cat_to_col_mapping[c] = i%10
    #end

    @filters = [
      BaseFilter,
      CatToColFilter.new({
        "Protected time for Specific Task & Finish Work": 6,
        "Work Related Travel (mark as Out of Office)": 3,
        "Just for Information (mark as Free)": 8,
        "Authorised Leave (annual  maternity etc)": 5,
        "Formal Event or Workshop": 10
        })
    ]

  end

  def gcal_api
    @gcal_api ||= client.discovered_api('calendar', 'v3')
  end

  ###

  def events
    result = client.execute(api_method:gcal_api.events.list, parameters: {'calendarId' => gcal_id, 'showDeleted' => true})
    gcal_events = result.data.items

    while result.next_page_token
      result = client.execute(result.next_page)
      gcal_events += result.data.items
    end

    return gcal_events
  end

  def event_for_id(id)
    result = client.execute(api_method:gcal_api.events.get, parameters: {'calendarId' => gcal_id, 'eventId' => id})
    return result.data
  end

  def instances_for_event_id(event_id)
    result = client.execute(api_method:gcal_api.events.instances, parameters: {'calendarId' => gcal_id, 'eventId' => event_id})
    gcal_instances = result.data.items

    while result.next_page_token
      result = client.execute(result.next_page)
      gcal_instances += result.data.items
    end

    return gcal_instances
  end

  ###

  def add_request_for_gcal_event_and_ical_event(gcal_event, ical_event)
    @pending_requests << insert(ical_event) if gcal_event.nil?
    @pending_requests << delete(gcal_event) if ical_event.nil? and gcal_event['recurring_event_id'].nil? and (gcal_event['status'] != 'cancelled')
    @pending_requests << update(gcal_event, ical_event) if gcal_event and ical_event
  end

  def google_calendar_representation_of_ical_event(ical_event)
    representation = {}

    @filters.each do |f|
      representation = f.call(ical_event, representation)
    end
    
    return representation
  end

  def insert(ical_event)
    {
      api_method: gcal_api.events.insert,
      headers: {'Content-Type' => 'application/json'},
      parameters: {'calendarId' => gcal_id},
      body:JSON.dump(google_calendar_representation_of_ical_event(ical_event))
    }
  end

  def delete(gcal_event)
    {
      api_method: gcal_api.events.delete,
      parameters: {'calendarId' => gcal_id, 'eventId' => gcal_event['id']},
    }
  end

  def update(gcal_event, ical_event)
    new_rep = google_calendar_representation_of_ical_event(ical_event)

    {
      api_method: gcal_api.events.update,
      headers: {'Content-Type' => 'application/json'},
      parameters: {'calendarId' => gcal_id, 'eventId' => ical_event.google_calendar_id},
      body:JSON.dump(new_rep)
    }
  end

  ###

  def execute_requests
    while @pending_requests.any?
      batch = Google::APIClient::BatchRequest.new
      
      @pending_requests.slice!(0,950).each do |r|
        batch.add r
      end
      
      @pending_requests = []
      return @client.execute(batch)
    end
  end


end