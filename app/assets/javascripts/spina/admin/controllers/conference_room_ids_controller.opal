# frozen_string_literal: true

require './list_items_controller'

class ConferenceRoomIdsController < ListItemsController
  def update_options
    get_xml { |xml| build_options(xml) }
  end
  def build_options(rooms)
    output_target = Browser::DOM::Element.new(output_options_target.to_n)
    options = rooms.xpath('rooms/room').collect do |element|
      DOM { option element[:name], value: element[:id].split('_')[-1] }
    end
    output_target.xpath('option').each(&:remove)
    options.each { |option| output_target << option }
    output_target.trigger :change
  end
end
