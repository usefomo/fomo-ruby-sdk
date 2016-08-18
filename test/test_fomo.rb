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
    event = FomoEventBasic.new
    event.event_type_id = '183'
    event.city = 'San Francisco'
    event.first_name = 'Dean'
    event.url = 'https://www.usefomo.com'
    event.title = 'Test event'
    created_event = client.create_event(event)
    puts(created_event.to_json)
    assert(event.first_name, created_event.first_name)

    # Get event
    event = client.get_event(created_event.id)
    assert(event.first_name, created_event.first_name)

    # Update event
    event.first_name = 'John'
    updated_event = client.update_event(event)
    assert('John', updated_event.first_name)

    # Delete event
    client.delete_event(updated_event.id)

    # List events
    list = client.get_events
    assert(0, list.count)

  end
end
