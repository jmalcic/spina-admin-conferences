# frozen_string_literal: true

require 'stimulus'
require 'browser'
require 'browser/http'

class ListItemsController < Stimulus::Controller #:nodoc:
  has_targets :input_id, :output_options

  def get_xml
    url = data[:url].decode_uri_component % input_id_target[:value]
    Browser::HTTP.get url do
      headers[:accept] = :'application/xml'
      on(:success) { yield response.xml }
    end
  end
end
