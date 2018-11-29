# frozen_string_literal: true

application = Stimulus::Application.new
[ConferenceRoomIdsController].each do |controller|
  application.register_controller controller
end
