# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class PresentationImportJob < ApplicationJob
        queue_as :default

        def perform(params)

        end
      end
    end
  end
end
