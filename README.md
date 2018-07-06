# Fomo Ruby SDK
[![Gem](https://img.shields.io/gem/v/fomo.svg)](https://rubygems.org/gems/fomo)
[![Gem](https://img.shields.io/gem/dt/fomo.svg)](https://rubygems.org/gems/fomo)

*Fomo Ruby SDK* is the official SDK wrapper for the [Fomo API service](https://fomo.com)

API docs: [https://docs.fomo.com](https://docs.fomo.com)

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

Check out [test/test_fomo.rb](test/test_fomo.rb), or get started below:

Initialize Fomo client:

```ruby
require 'fomo'
client = Fomo.new('<auth-token>') # // auth token can be found in Fomo application admin dashboard (App -> API Access)
```

Create a new event:

```ruby
event = FomoEvent.new
event.event_type_id = '183' # Template ID is found inside Fomo > Templates -> Template ID
event.email_address = 'ryan.kulp@usefomo.com', # used for creating Avatars in notifications
event.ip_address = '128.177.108.102', # used for extracting location parameters
event.first_name = 'Ryan'
event.url = 'https://www.usefomo.com'
event.title = 'Test event'

# you can also create events with event.event_type_tag
# this is useful for multiple environments with different template IDs

# Add event custom attributes
event.add_custom_event_field('variable_name', 'value')

created_event = client.create_event(event)
```

Fetch an event:

```ruby
event = client.get_event('<event-id>')
```

Get a collection of events:

```ruby
list = client.get_events(30, 1)
```

Get events with metadata:

```ruby
data = client.get_events_with_meta(30, 1)
events = data.events
puts data.meta.per_page
puts data.meta.page
puts data.meta.total_count
puts data.meta.total_pages
```

Delete an event:

```ruby
client.delete_event('<event-id>')
```

Update an event:

```ruby
event = client.get_event('<event-id>')
event.first_name = 'John'
updated_event = client.update_event(event)
```

## Support

If you have questions, email us at [hello@fomo.com](mailto:hello@fomo.com).
