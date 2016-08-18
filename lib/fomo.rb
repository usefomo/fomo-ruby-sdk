# Copyright (c) 2016. Fomo. https://www.usefomo.com
#
# Author:: Fomo (mailto:hello@usefomo.com)
# Copyright:: Copyright (c) 2016. Fomo. https://www.usefomo.com
# License:: MIT

require 'net/http'
require 'json'

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
    j = JSON.parse(response)
    FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['url'], j['first_name'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes'])
  end

  # Get events
  #
  # Returns an array of FomoEvent objects.
  #
  def get_events
    response = make_request('/api/v1/applications/me/events', 'GET')
    data = JSON.parse(response)
    list = []
    data.each do |j|
      list.push(FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['url'], j['first_name'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes']))
    end
    list
  end

  # Create event
  #
  # Arguments:
  #   event: (FomoEventBasic) Fomo event
  #
  # Returns an FomoEvent object.
  #
  def create_event(event)
    response = make_request('/api/v1/applications/me/events', 'POST', event)
    j = JSON.parse(response)
    FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['url'], j['first_name'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes'])
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
    j = JSON.parse(response)
    FomoDeleteMessageResponse.new(j['message'])
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
    j = JSON.parse(response)
    FomoEvent.new(j['id'], j['created_at'], j['updated_at'], j['message'], j['link'], j['event_type_id'], j['url'], j['first_name'], j['city'], j['province'], j['country'], j['title'], j['image_url'], j['custom_event_fields_attributes'])
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
    # puts(method + ' ' + @endpoint + api_path)
    uri = URI.parse(@endpoint + api_path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = {
        'Authorization' => 'Token ' + @auth_token
    }
    case method
      when 'GET'
        request = Net::HTTP::Get.new(uri.path, initheader=headers)
        response = http.request(request)
        return response.body
      when 'POST'
        headers['Content-Type'] = 'application/json'
        request = Net::HTTP::Post.new(uri.path, initheader=headers)
        request.body = data.to_json
        response = http.request(request)
        return response.body
      when 'PATCH'
        headers['Content-Type'] = 'application/json'
        request = Net::HTTP::Patch.new(uri.path, initheader=headers)
        request.body = data.to_json
        response = http.request(request)
        return response.body
      when 'DELETE'
        request = Net::HTTP::Delete.new(uri.path, initheader=headers)
        response = http.request(request)
        return response.body
      else
        puts('Unknown method')
    end
  end
end

# This class holds attributes of basic event, object is needed when creating new event
class FomoEventBasic

  # Event type unique ID (required)
  attr_accessor :event_type_id

  # Url to redirect on the event click. Size range: 0..255 (required)
  attr_accessor :url

  # First name of the person on the event. Size range: 0..255
  attr_accessor :first_name

  # City where the event happened. Size range: 0..255
  attr_accessor :city

  # Province where the event happened. Size range: 0..255
  attr_accessor :province

  # Country where the event happened ISO-2 standard. Size range: 0..255
  attr_accessor :country

  # Title of the event. Size range: 0..255
  attr_accessor :title

  # Url of the image to be displayed. Size range: 0..255
  attr_accessor :image_url

  # Array to create custom event fields
  attr_accessor :custom_event_fields_attributes

  # Initializes FomoEventBasic object
  def initialize(event_type_id='', url='', first_name='', city='', province='', country='', title='', image_url='', custom_event_fields_attributes = [])
    @event_type_id = event_type_id
    @url = url
    @first_name = first_name
    @city = city
    @province = province
    @country = country
    @title = title
    @image_url = image_url
    @custom_event_fields_attributes = custom_event_fields_attributes
  end

  # Add custom event field
  #
  # Arguments:
  #   key: Custom attribute key
  #   value: Custom attribute value
  #
  def add_custom_event_field(key, value)
    @custom_event_fields_attributes[] = {'key' => key, 'value' => value}
  end

  # Return JSON serialized object
  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.sub(/^@/, '')] = self.instance_variable_get var
    end
    hash.to_json
  end
end

# This class holds attributes of event, object returned by API
class FomoEvent
  # Event ID
  attr_accessor :id

  # Created timestamp
  attr_accessor :created_at

  # Updated timestamp
  attr_accessor :updated_at

  # Message template
  attr_accessor :message

  # Full link
  attr_accessor :link

  # Event type unique ID (required)
  attr_accessor :event_type_id

  # Url to redirect on the event click. Size range: 0..255 (required)
  attr_accessor :url

  # First name of the person on the event. Size range: 0..255
  attr_accessor :first_name

  # City where the event happened. Size range: 0..255
  attr_accessor :city

  # Province where the event happened. Size range: 0..255
  attr_accessor :province

  # Country where the event happened ISO-2 standard. Size range: 0..255
  attr_accessor :country

  # Title of the event. Size range: 0..255
  attr_accessor :title

  # Url of the image to be displayed. Size range: 0..255
  attr_accessor :image_url

  # Array to create custom event fields
  attr_accessor :custom_event_fields_attributes

  # Initializes FomoEvent object
  def initialize(id='', created_at='', updated_at='', message='', link='', event_type_id='', url='', first_name='', city='', province='', country='', title='', image_url='', custom_event_fields_attributes = [])
    @id = id
    @created_at = created_at
    @updated_at = updated_at
    @message = message
    @link = link
    @event_type_id = event_type_id
    @url = url
    @first_name = first_name
    @city = city
    @province = province
    @country = country
    @title = title
    @image_url = image_url
    @custom_event_fields_attributes = custom_event_fields_attributes
  end

  # Add custom event field
  #
  # Arguments:
  #   key: Custom attribute key
  #   value: Custom attribute value
  #
  def add_custom_event_field(key, value)
    @custom_event_fields_attributes[] = {'key' => key, 'value' => value}
  end

  # Return JSON serialized object
  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.sub(/^@/, '')] = self.instance_variable_get var
    end
    hash.to_json
  end
end

# This class holds attributes of Fomo delete response, object returned by API
class FomoDeleteMessageResponse

  # Message
  attr_accessor :message

  # Initializes FomoDeleteMessageResponse object
  def initialize(message='')
    @message = message
  end

  # Return JSON serialized object
  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.sub(/^@/, '')] = self.instance_variable_get var
    end
    hash.to_json
  end
end