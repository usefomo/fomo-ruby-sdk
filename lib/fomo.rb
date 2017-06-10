# Copyright (c) 2017. Fomo. https://www.usefomo.com
#
# Author:: Fomo (mailto:hello@usefomo.com)
# Copyright:: Copyright (c) 2017. Fomo. https://www.usefomo.com
# License:: MIT

require 'net/https'
require 'json'
require 'fomo_event'
require 'fomo_delete_message_response'
require 'fomo_meta_data'
require 'fomo_events_with_meta'

# Fomo Client is wrapper around official Fomo API (https://www.usefomo.com)
class Fomo

  # Fomo Authorization token
  attr_accessor :auth_token

  # Fomo API Endpoint
  attr_accessor :endpoint

  # Initializes Fomo Client with authorization token
  #
  # Arguments:
  #   auth_token: (String) Fomo Authorization token
  #
  def initialize (auth_token)
    @auth_token = auth_token
    @version = '0.0.6'
    @endpoint = 'https://www.usefomo.com'
  end

  # Get event
  #
  # Arguments:
  #   id: (String) Event ID
  #
  # Returns an FomoEvent object.
  #
  def get_event(id)
    response = make_request('/api/v1/applications/me/events/' + id.to_s, 'GET')
    begin
      j = JSON.parse(response)
      FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['event_type_tag'], j['url'], j['first_name'], j['email_address'], j['ip_address'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes'])
    rescue JSON::ParserError => _
      # String was not valid
    end
  end

  # Get events
  #
  # Arguments:
  #   size: (Number) Page size
  #   page: (Number) Page number
  #
  # Returns an array of FomoEvent objects.
  #
  def get_events(size = 30, page = 1)
    response = make_request('/api/v1/applications/me/events?per=' + size.to_s + '&page=' + page.to_s, 'GET')
    begin
      data = JSON.parse(response)
      list = []
      data.each do |j|
        list.push(FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['event_type_tag'], j['url'], j['first_name'], j['email_address'], j['ip_address'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes']))
      end
      list
    rescue JSON::ParserError => _
      # String was not valid
    end
  end

  # Get events with meta data
  #
  # Arguments:
  #   size: (Number) Page size
  #   page: (Number) Page number
  #
  # Returns an FomoEventsWithMeta object.
  #
  def get_events_with_meta(size = 30, page = 1)
    response = make_request('/api/v1/applications/me/events?per=' + size.to_s + '&page=' + page.to_s + '&show_meta=true', 'GET')
    begin
      data = JSON.parse(response)

      list = []
      data['events'].each do |j|
        list.push(FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['event_type_tag'], j['url'], j['first_name'], j['email_address'], j['ip_address'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes']))
      end
      meta = FomoMetaData.new(data['meta']['per_page'].to_i, data['meta']['page'].to_i, data['meta']['total_count'].to_i, data['meta']['total_pages'].to_i)
      FomoEventsWithMeta.new(list, meta)
    rescue JSON::ParserError => _
      # String was not valid
    end
  end

  # Create event
  #
  # Arguments:
  #   event: (FomoEvent) Fomo event
  #   event_type_id: (String) Event type ID
  #   event_type_tag: (String) Event type tag
  #   url: (String) Event URL
  #   first_name: (String) First name
  #   email_address: (String) Email address
  #   ip_address: (String) IP address
  #   city: (String) City
  #   province: (String) Province
  #   country: (String) Country
  #   title: (String) Event title
  #   image_url: (String) Event Image URL
  #   custom_event_fields_attributes: (array) Custom event attributes
  #
  # Returns an FomoEvent object.
  #
  def create_event(event={})
    if event == {}
      puts "No event provided - please provide a FomoEvent object or hash of parameters"
      return
    end

    response = make_request('/api/v1/applications/me/events', 'POST', event)
    begin
      j = JSON.parse(response)
      FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['event_type_tag'], j['url'], j['first_name'], j['email_address'], j['ip_address'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes'])
    rescue JSON::ParserError => _
      # String was not valid
    end
  end

  # Delete event
  #
  # Arguments:
  #   id: (String) Event ID
  #
  # Returns an FomoDeleteMessageResponse object.
  #
  def delete_event(id)
    response = make_request('/api/v1/applications/me/events/' + id.to_s, 'DELETE')
    begin
      j = JSON.parse(response)
      FomoDeleteMessageResponse.new(j['message'])
    rescue JSON::ParserError => _
      # String was not valid
    end
  end

  # Update event
  #
  # Arguments:
  #   event: (FomoEvent) Fomo event
  #
  # Returns an FomoEvent object.
  #
  def update_event(event)
    response = make_request('/api/v1/applications/me/events/' + event.id.to_s, 'PATCH', event)
    begin
      j = JSON.parse(response)
      FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['event_type_tag'], j['url'], j['first_name'], j['email_address'], j['ip_address'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes'])
    rescue JSON::ParserError => _
      # String was not valid
    end
  end

  # Make authorized request to Fomo API
  #
  # Arguments:
  #   api_path: (String) API path
  #   method: (String) HTTP method
  #   data: (Object) Object to send, object is JSON serialized before it is sent
  #
  # Returns an JSON string.
  #
  def make_request(api_path, method, data = nil)
    uri = URI.parse(@endpoint + api_path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = {
        'Authorization' => 'Token ' + @auth_token,
        'User-Agent' => 'Fomo/Ruby/' + @version
    }
    case method
      when 'GET'
        request = Net::HTTP::Get.new(api_path, initheader=headers)
        response = http.request(request)
        return response.body
      when 'POST'
        headers['Content-Type'] = 'application/json'
        request = Net::HTTP::Post.new(api_path, initheader=headers)
        request.body = data.to_json
        response = http.request(request)
        return response.body
      when 'PATCH'
        headers['Content-Type'] = 'application/json'
        request = Net::HTTP::Patch.new(api_path, initheader=headers)
        request.body = data.to_json
        response = http.request(request)
        return response.body
      when 'DELETE'
        request = Net::HTTP::Delete.new(api_path, initheader=headers)
        response = http.request(request)
        return response.body
      else
        puts('Unknown method')
    end
  end
end
