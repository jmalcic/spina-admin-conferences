# frozen_string_literal: true

class PresentationTypeIdsController < ListItemsController
  def update_options
    get_xml { |xml| build_options(xml) }
  end
  def build_options(presentation_types)
    output_target = Browser::DOM::Element.new(output_options_target.to_n)
    options =
      presentation_types.xpath('presentationtypes/presentationtype').collect do |element|
        DOM { option element.inner_html, value: element[:id].split('_')[-1] }
      end
    output_target.xpath('option').each(&:remove)
    options.each { |option| output_target << option }
    output_target.trigger :change
  end
end
