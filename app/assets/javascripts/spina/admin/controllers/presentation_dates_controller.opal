# frozen_string_literal: true

class PresentationDatesController < ListItemsController
  def update_options
    get_xml { |xml| build_options(xml) }
  end
  def build_options(conference)
    output_target = Browser::DOM::Element.new(output_options_target.to_n)
    options = conference.xpath('conference/dates/time').collect do |element|
      DOM { option element.inner_html, value: element[:datetime] }
    end
    output_target.xpath('option').each_with_index do |option, index|
      option.replace options[index]
    end
  end
end
