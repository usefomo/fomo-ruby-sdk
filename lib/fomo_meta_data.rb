# Copyright (c) 2017. Fomo. https://www.usefomo.com
#
# Author:: Fomo (mailto:hello@usefomo.com)
# Copyright:: Copyright (c) 2017. Fomo. https://www.usefomo.com
# License:: MIT

require 'json'

# This class holds attributes of event, object returned by API
class FomoMetaData

  # Page size
  attr_accessor :per_page

  # Page number
  attr_accessor :page

  # Total count
  attr_accessor :total_count

  # Total pages
  attr_accessor :total_pages

  # Initializes FomoMetaData object
  def initialize(per_page=30, page=1, total_count=0, total_pages=1)
    @per_page = per_page
    @page = page
    @total_count = total_count
    @total_pages = total_pages
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