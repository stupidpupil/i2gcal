
describe Synchrograph do
  before do
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.parse(Base64.decode64(ENV['SPEC_CLIENT_SECRETS'])))
    refresh_token = ENV['SPEC_REFRESH_TOKEN']

    @client = APIClientBuilder.new_client_with_refresh_token(refresh_token, client_secrets)

    calendar_id = ENV['SPEC_GCAL_ID']
    @gcalendar = GCalendar.new(@client, calendar_id)

    @synchrograph =  Synchrograph.new(@client)

  end

  describe 'when I sync the calendars' do
    it 'must do the right thing!' do

      icalendar = Icalendar::Calendar.parse(File.read(File.expand_path('160730_bank_holidays.ics', FIXTURES_DIR)))
      result = @synchrograph.synchronise(@gcalendar, icalendar)

      event = @gcalendar.event_for_id('6786b9963f7953ba853deb71dcd6e93d')
      event['status'].should.equal 'confirmed'
      event['summary'].should.equal 'Early May bank holiday'
      event['start'].date.should.equal '2016-05-02'

      icalendar = Icalendar::Calendar.parse(File.read(File.expand_path('160730_clock_changes.ics', FIXTURES_DIR)))
      result = @synchrograph.synchronise(@gcalendar, icalendar)

      event = @gcalendar.event_for_id('6786b9963f7953ba853deb71dcd6e93d')
      event['status'].should.equal 'cancelled'

      event = @gcalendar.event_for_id('9be915db72da5ee692c634e564bbe06c')
      event['status'].should.equal 'confirmed'
      event['summary'].should.equal 'Start of British Summer Time'
      event['start'].date.should.equal '2015-03-29'


    end
  end

end