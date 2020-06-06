# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # @abstract Abstract mailer from which all others inherit.
      class ApplicationMailer < ActionMailer::Base
        default from: 'from@example.com'
        layout 'mailer'
      end
    end
  end
end
