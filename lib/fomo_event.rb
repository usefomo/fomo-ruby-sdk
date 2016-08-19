# Copyright (c) 2016. Fomo. https://www.usefomo.com
#
# Author:: Fomo (mailto:hello@usefomo.com)
# Copyright:: Copyright (c) 2016. Fomo. https://www.usefomo.com
# License:: MIT

require 'json'

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
  #   id: Custom attribute ID
  #
  def add_custom_event_field(key, value, id='')
    if id == ''
      @custom_event_fields_attributes.push({'key' => key, 'value' => value})
    else
      @custom_event_fields_attributes.push({'key' => key, 'value' => value, 'id' => id})
    end
  end

  # Return JSON serialized object
  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.sub(/^@/, '')] = self.instance_variable_get var
    end
    '{"event":' + hash.to_json + '}'
  end
end
