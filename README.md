# Fomo Ruby SDK

*Fomo Ruby SDK* is the official SDK wrapper for the [Fomo API service](https://www.usefomo.com)

API docs: [http://docs.usefomo.com/reference](http://docs.usefomo.com/reference)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fomo', '~> 0.0.1'

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
client = Fomo.new('<auth-token>') # // auth token can be found Fomo application admin dashboard (App -> API Access)
```

To create a new event:

```ruby
event = FomoEventBasic.new
event.event_type_id = '183' # Event type ID is found on Fomo dashboard (Templates -> Template ID)
event.city = 'San Francisco'
event.first_name = 'Dean'
event.url = 'https://www.usefomo.com'
event.title = 'Test event'
created_event = client.create_event(event)
```

To get an event:

```ruby
event = client.get_event('<event-id>')
```

To get all events:

```ruby
list = client.get_events
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
