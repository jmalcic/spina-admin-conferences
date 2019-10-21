# frozen_string_literal: true

module Spina
  module Conferences
    # Base mailer from which other mailers inherit
    class ApplicationMailer < ActionMailer::Base
      default from: 'from@example.com'
      layout 'mailer'
    end
  end
end
