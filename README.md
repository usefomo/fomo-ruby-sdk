# Fomo Ruby SDK
[![Gem](https://img.shields.io/gem/v/fomo.svg)](https://rubygems.org/gems/fomo)
[![Gem](https://img.shields.io/gem/dt/fomo.svg)](https://rubygems.org/gems/fomo)

*Fomo Ruby SDK* is the official SDK wrapper for the [Fomo API service](https://www.usefomo.com)

API docs: [http://docs.usefomo.com/reference](http://docs.usefomo.com/reference)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fomo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fomo

## Usage

### Basic usage

Check out our examples in [test/test_fomo.rb](test/test_fomo.rb), quick usage examples:

Initialize Fomo client via:

```ruby
require 'fomo'
client = Fomo.new('<auth-token>') # // auth token can be found in Fomo application admin dashboard (App -> API Access)
```

To create a new event directly with template name:

```ruby
client.create_event(event_type_tag: 'new_order', # Event type tag is found on Fomo dashboard (Templates -> Template name)
                    city: 'New York',
                    first_name: 'Ryan',
                    ip_address: '128.177.108.102', # used for extracting location parameters
                    email_address: 'ryan.kulp@usefomo.com', # used for creating Avatars in notifications
                    url: 'https://www.usefomo.com',
                    title: 'Test event',
                    custom_event_fields_attributes: [{'key' => 'variable_name', 'value' => 'value'}])
```


To create a new event directly with template ID:

```ruby
client.create_event(event_type_id: '183', # Event type ID is found on Fomo dashboard (Templates -> Template ID)
                    city: 'San Francisco',
                    first_name: 'Dean',
                    ip_address: '128.177.108.102',
                    email_address: 'dean@somewhere.com',
                    url: 'https://www.usefomo.com',
                    title: 'Test event',
                    custom_event_fields_attributes: [{'key' => 'variable_name', 'value' => 'value'}])
```

To create a new event with object:

```ruby
event = FomoEventBasic.new
event.event_type_id = '183' # Event type ID is found on Fomo dashboard (Templates -> Template ID)
event.city = 'San Francisco'
event.first_name = 'Dean'
event.url = 'https://www.usefomo.com'
event.title = 'Test event'

# Add event custom attribute value
event.add_custom_event_field('variable_name', 'value')

created_event = client.create_event(event)
```

To get an event:

```ruby
event = client.get_event('<event-id>')
```

To get events:

```ruby
list = client.get_events(30, 1)
```

To get events with metadata:

```ruby
data = client.get_events_with_meta(30, 1)
events = data.events
puts data.meta.per_page
puts data.meta.page
puts data.meta.total_count
puts data.meta.total_pages
```

To delete an event:

```ruby
client.delete_event('<event-id>')
```

To update an event:

```ruby
event = client.get_event('<event-id>')
event.first_name = 'John'
updated_event = client.update_event(event)
```

## Support

If you have questions, email us at [hello@usefomo.com](mailto:hello@usefomo.com).
