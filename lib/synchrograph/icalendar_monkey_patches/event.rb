module Icalendar
  class Event

    def google_calendar_id=(gcal_id)
      @gcal_id = gcal_id
    end

    def google_calendar_id
      @gcal_id ||= UUIDTools::UUID.sha1_create(UUID_ICAL_TO_GCAL_NAMESPACE,uid).hexdigest
    end

    def exdates
      exdate.map {|r| "EXDATE:#{[r].flatten.map {|s| s.value_with_tz.utc.strftime('%Y%m%dT%H%M%S')+'Z'}.join(',')}"}
    end

    def rdates
      rdate.map {|r| "RDATE:#{[r].flatten.map {|s| s.value_with_tz.utc.strftime('%Y%m%dT%H%M%S')+'Z'}.join(',')}"}
    end



    ###

    def parent_component
      return nil if recurrence_id.nil? 
      @parent_component ||=  parent.events.find {|p| p.recurrence_id.nil? and (p.uid == self.uid)}
    end

    def update_from_parent_component!
      return if parent_component.nil?

      [:summary, :description, :location, :geo].each do |desc_prop|
        self.send("#{desc_prop}=".to_sym, parent_component.send(desc_prop)) if self.send(desc_prop).nil? 
      end

    end

  end
end