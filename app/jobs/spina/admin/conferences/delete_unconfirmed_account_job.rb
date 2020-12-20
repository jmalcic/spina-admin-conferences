# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class DeleteUnconfirmedAccountJob < ApplicationJob
        queue_as :default

        def perform(account)
          account.destroy if account.unconfirmed?
        end
      end
    end
  end
end
