module Icalendar
  module Values

    class Date
      include BetterTimezones

      def google_calendar_representation
        {
          'date' => self.strftime('%F'),
          'timeZone' => tzinfo.name
        }
      end

    end

    class DateTime
      include BetterTimezones

      def google_calendar_representation
        {
          'dateTime' => self.strftime('%FT%T'),
          'timeZone' => tzinfo.name
        }
      end
    end
  end

end