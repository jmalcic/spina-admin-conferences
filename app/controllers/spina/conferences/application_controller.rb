# frozen_string_literal: true

module Spina
  module Conferences
    # Base class from which controllers inherit
    class ApplicationController < ::Spina::ApplicationController
      protect_from_forgery with: :exception
    end
  end
end
