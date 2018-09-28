# frozen_string_literal: true

class PresentationRoomUseIdsController < ListItemsController
  def update_options
    get_xml { |xml| build_options(xml) }
  end
  def build_options(room_uses)
    output_target = Browser::DOM::Element.new(output_options_target.to_n)
    options = room_uses.xpath('roomuses/roomuse').collect do |element|
      DOM { option element.at_xpath('room').inner_html, value: element[:id].split('_')[-1] }
    end
    options.each_with_index do |option, index|
      if output_target.xpath('option')[index]
        output_target.xpath('option')[index].replace option
      else
        output_target << option
      end
    end
  end
end
