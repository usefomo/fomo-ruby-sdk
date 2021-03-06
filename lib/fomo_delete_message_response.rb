# Copyright (c) 2018. Fomo. https://fomo.com
#
# Author:: Fomo (mailto:hello@fomo.com)
# Copyright:: Copyright (c) 2018. Fomo. https://fomo.com
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