# frozen_string_literal: true

require_tree './controllers'

application = Stimulus::Application.new
[PresentationTypeIdsController,
 PresentationDatesController,
 PresentationRoomUseIdsController].each do |controller|
  application.register_controller controller
end
