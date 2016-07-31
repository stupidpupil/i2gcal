module Icalendar
  module Values
    module BetterTimezones

      regex = /<!-- (\(UTC.+?)\s+-->[\s|$]+<mapZone .+? type="(.+?)"\/>/
      wz_path = File.expand_path('../../../../data/windowsZones.xml', __FILE__)
      wz = File.read(wz_path)
      WINDOWS_TZID_MAP = Hash[wz.scan(regex)]

      def tzinfo
        return time_zone.tzinfo if self.respond_to? :time_zone

        tzid = ical_params['tzid']
        tzid = tzid.first if tzid and tzid.any?

        if tzid
          return TZInfo::Timezone.get(WINDOWS_TZID_MAP[tzid]) if WINDOWS_TZID_MAP.has_key? tzid
          return TZInfo::Timezone.get(tzid) if TZInfo::Timezone.all_identifiers.include? tzid
        end

        return TZInfo::Timezone.get('Etc/UTC')
      end

      def value_with_tz
        ActiveSupportTimeWithZoneAdapter.new nil, tzinfo, value
      end

    end
  end
end