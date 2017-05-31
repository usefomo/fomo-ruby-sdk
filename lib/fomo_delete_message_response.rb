# Copyright (c) 2017. Fomo. https://www.usefomo.com
#
# Author:: Fomo (mailto:hello@usefomo.com)
# Copyright:: Copyright (c) 2017. Fomo. https://www.usefomo.com
# License:: MIT

require 'json'

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