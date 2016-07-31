class BaseFilter

    def self.call(ical_event, representation)
      {
        'summary' => ical_event.summary,
        'start' =>  ical_event.dtstart.google_calendar_representation,
        'end'   =>  ical_event.dtend.google_calendar_representation,
        'location' => ical_event.location,
        'description' => ical_event.description,
        'id' => ical_event.google_calendar_id,
        'status' => 'confirmed',
        'recurrence' => ical_event.rrule.map {|r| "RRULE:#{r.value_ical}"} + ical_event.rdates + ical_event.exdates
      }.delete_if {|k,v| v.nil? }
    end

end