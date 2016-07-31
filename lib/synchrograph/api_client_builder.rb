require 'google/api_client'

class APIClientBuilder

  def self.new_client(client_secrets)
    client = Google::APIClient.new(application_name:'stupidpupil_icalendar', application_version:'0.0.1')
    client.authorization.scope = 'https://www.googleapis.com/auth/calendar'

    client.authorization.client_id = client_secrets.client_id
    client.authorization.client_secret = client_secrets.client_secret
    client.authorization.redirect_uri = client_secrets.redirect_uris.first

    return client
  end

  def self.new_client_with_refresh_token(refresh_token, client_secrets)
    client = new_client(client_secrets)
    client.authorization.refresh_token = refresh_token
    client.authorization.fetch_access_token!

    return client
  end

end