# frozen_string_literal: true

application = Stimulus::Application.new
[PresentationTypeIdsController,
 PresentationDatesController,
 PresentationRoomUseIdsController].each do |controller|
  application.register_controller controller
end
