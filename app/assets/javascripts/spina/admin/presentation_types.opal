# frozen_string_literal: true

application = Stimulus::Application.new
[PresentationTypeRoomUseIdsController].each do |controller|
  application.register_controller controller
end
