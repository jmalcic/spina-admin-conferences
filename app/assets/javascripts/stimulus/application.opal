# frozen_string_literal: true

module Stimulus
  class Application #:nodoc:
    def initialize
      @native = Native(`Stimulus.Application.start()`)
    end

    def register_controller(controller, identifier = controller.identifier)
      @native.register(identifier, controller.new.native_class)
    end
  end
end
