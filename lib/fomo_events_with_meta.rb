# Copyright (c) 2016. Fomo. https://www.usefomo.com
#
# Author:: Fomo (mailto:hello@usefomo.com)
# Copyright:: Copyright (c) 2016. Fomo. https://www.usefomo.com
# License:: MIT

require 'json'

# This class holds attributes of event, object returned by API
class FomoEventsWithMeta

  # List of events
  attr_accessor :events

  # Meta data
  attr_accessor :meta

  # Initializes FomoMetaData object
  def initialize(events=[], meta=nil)
    @events = events
    @meta = meta
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