require 'minitest/autorun'
require 'fomo'
require 'json'

class FomoTest < Minitest::Test
  def test_fomo
    # Initializes Fomo Client
    client = Fomo.new('<token>')

    # List current events and delete all of them
    list = client.get_events
    list.each {|event| client.delete_event(event.id)}

    # List events
    list = client.get_events
    assert(0, list.count)

    # Create event
    event = FomoEvent.new
    event.event_type_id = '3236'
    event.city = 'New York City'
    event.first_name = 'Ryan'
    event.email_address = 'ryan.kulp@usefomo.com'
    event.ip_address = '128.177.108.102'
    event.url = 'https://www.usefomo.com'
    event.title = 'Test event'

    # Add custom attributes to event
    event.add_custom_event_field('variable_name', 'value')
    created_event = client.create_event(event)

    puts(created_event.to_json)
    assert(event.first_name, created_event.first_name)
    assert('value', created_event.custom_event_fields_attributes[0]['value'])

    # List events
    list = client.get_events
    assert(1, list.count)

    # List events with meta
    listWithMeta = client.get_events_with_meta(30, 1)
    assert(1, listWithMeta.events.count)
    assert(1, listWithMeta.meta.total_count)
    assert(30, listWithMeta.meta.per_page)
    assert(1, listWithMeta.meta.page)
    assert(1, listWithMeta.meta.total_pages)

    # Get event
    event = client.get_event(created_event.id)
    assert(event.first_name, created_event.first_name)

    # Update event
    event.first_name = 'John'
    event.custom_event_fields_attributes[0] = 'changed_value'
    updated_event = client.update_event(event)
    assert('John', updated_event.first_name)
    assert('changed_value', updated_event.custom_event_fields_attributes[0])

    # Delete event
    client.delete_event(updated_event.id)

    # List events
    list = client.get_events
    assert(0, list.count)
  end
end
